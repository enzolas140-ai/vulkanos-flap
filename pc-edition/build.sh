#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")"
ROOT="$PWD"
BOOT="$ROOT/boot"
INCLUDES="$ROOT/config/includes.chroot"
THEME="$INCLUDES/usr/share/plymouth/themes/vulkanos"
PACKAGES="$ROOT/config/packages.chroot"

if [[ "$(id -u)" -ne 0 ]]; then
  echo "Run this build inside Debian 13 as root." >&2
  exit 1
fi

command -v rsvg-convert >/dev/null 2>&1 || {
  echo "rsvg-convert is required (package: librsvg2-bin)." >&2
  exit 1
}
python3 -c "from PIL import Image" >/dev/null 2>&1 || {
  echo "Python Pillow is required (package: python3-pil)." >&2
  exit 1
}

# Generate the BIOS/UEFI boot-menu background and the transparent white logo.
mkdir -p "$THEME" "$PACKAGES"
rsvg-convert -w 640 -h 480 "$BOOT/boot-menu.svg" -o "$BOOT/boot-menu.png"
rsvg-convert -w 512 -h 512 "$BOOT/vulkanos-volcano.svg" -o "$THEME/vulkanos-volcano.png"
python3 - "$BOOT/boot-menu.png" "$BOOT/boot-menu.tga" <<'PY'
from PIL import Image
import sys
with Image.open(sys.argv[1]) as image:
    image.convert("RGB").save(sys.argv[2], format="TGA")
PY

# Compile a custom-configured Linux x86-64 kernel as a Debian package.
# live-build installs the .deb from config/packages.chroot.
rm -f "$PACKAGES"/linux-image-*-vulkanos_*.deb
bash "$ROOT/kernel/build-kernel.sh"

KERNEL_DEB="$(find "$PACKAGES" -maxdepth 1 -type f -name 'linux-image-*-vulkanos_*.deb' ! -name '*-dbg*' | sort -V | tail -n 1)"
test -s "$KERNEL_DEB"
KERNEL_PACKAGE="$(dpkg-deb -f "$KERNEL_DEB" Package)"
KERNEL_VERSION="$(dpkg-deb -f "$KERNEL_DEB" Version)"
KERNEL_ARCH="$(dpkg-deb -f "$KERNEL_DEB" Architecture)"
cat > "$ROOT/KERNEL-INFO.txt" <<EOF
VulkanOS PC custom kernel
Package: $KERNEL_PACKAGE
Package version: $KERNEL_VERSION
Architecture: $KERNEL_ARCH
Source: Debian Linux source for Trixie, configured and compiled by VulkanOS
Build: 0.3.0-alpha
This is a custom-compiled Linux kernel package, not a kernel written from scratch.
The matching source archive and .config are distributed alongside the ISO.
The kernel is unsigned; Secure Boot may need to be disabled on PCs that enforce signed boot components.
EOF

chmod +x config/hooks/normal/*.hook.chroot

# live-build reads the bootloader customizations through LB_* variables.
export LB_SYSLINUX_SPLASH="$BOOT/boot-menu.png"
export LB_SYSLINUX_TIMEOUT=80
export LB_SYSLINUX_MENU_LIVE_ENTRY="INICIAR VULKANOS LIVE"
export LB_GRUB_SPLASH="$BOOT/boot-menu.tga"

lb config \
  --distribution trixie \
  --architectures amd64 \
  --binary-images iso-hybrid \
  --bootloaders "syslinux grub-efi" \
  --archive-areas "main contrib non-free non-free-firmware" \
  --debian-installer live \
  --debian-installer-gui true \
  --linux-packages none \
  --memtest none \
  --uefi-secure-boot disable \
  --bootappend-live "boot=live components quiet splash username=vulkan hostname=vulkanos locales=pt_BR.UTF-8 keyboard-layouts=br" \
  --iso-application "VulkanOS PC Edition" \
  --iso-publisher "VulkanOS Project" \
  --iso-volume "VULKANOS_PC_A03" \
  --apt-recommends false \
  --firmware-chroot true \
  --firmware-binary true

unset LB_SYSLINUX_SPLASH LB_SYSLINUX_TIMEOUT LB_SYSLINUX_MENU_LIVE_ENTRY LB_GRUB_SPLASH

# Copy the distribution's complete bootloader templates, then brand the
# Syslinux and GRUB boot menus without replacing live-build's generated entries.
rm -rf config/bootloaders
mkdir -p config/bootloaders
cp -a /usr/share/live/build/bootloaders/. config/bootloaders/
cp "$BOOT/boot-menu.png" config/bootloaders/isolinux/splash.png
rm -f config/bootloaders/isolinux/splash.svg
cp "$BOOT/boot-menu.tga" config/bootloaders/grub-pc/splash.tga

for menu_file in \
  config/bootloaders/syslinux_common/install_gui.cfg \
  config/bootloaders/syslinux_common/install_text.cfg; do
  if [[ -f "$menu_file" ]]; then
    sed -i 's/^menu label.*/menu label ^INSTALAR VULKANOS/' "$menu_file"
  fi
done
if [[ -f config/bootloaders/syslinux_common/stdmenu.cfg ]]; then
  sed -i 's/^menu title.*/menu title VULKANOS PC EDITION - MENU DE INICIALIZACAO/' \
    config/bootloaders/syslinux_common/stdmenu.cfg
fi

lb build

ISO="live-image-amd64.hybrid.iso"
test -s "$ISO"
mv "$ISO" "VulkanOS-PC-Alpha-0.3-amd64.iso"
sha256sum "VulkanOS-PC-Alpha-0.3-amd64.iso" > SHA256SUMS
ls -lh "VulkanOS-PC-Alpha-0.3-amd64.iso" SHA256SUMS KERNEL-INFO.txt KERNEL-CONFIG KERNEL-SOURCE.tar.xz
