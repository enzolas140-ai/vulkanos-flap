#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORK="/tmp/vulkanos-kernel-build"
OUT="$ROOT/config/packages.chroot"
mkdir -p "$WORK" "$OUT"
rm -f "$OUT"/linux-image-*-vulkanos_*.deb
rm -f "$WORK"/linux-image-*.deb "$WORK"/linux-headers-*.deb

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends \
  build-essential bc bison flex libssl-dev libelf-dev libncurses-dev \
  dwarves rsync cpio kmod xz-utils fakeroot debhelper lsb-release linux-source linux-image-amd64

SOURCE_ARCHIVE="$(find /usr/src -maxdepth 1 -type f \( -name 'linux-source-*.tar.xz' -o -name 'linux-source-*.tar.zst' \) | sort -V | tail -n 1)"
if [[ -z "$SOURCE_ARCHIVE" ]]; then
  echo "Debian linux-source archive not found in /usr/src." >&2
  exit 1
fi

rm -rf "$WORK"/linux-source-*
tar -xf "$SOURCE_ARCHIVE" -C "$WORK"
KERNEL_DIR="$(find "$WORK" -mindepth 1 -maxdepth 1 -type d -name 'linux-source-*' | head -n 1)"
if [[ -z "$KERNEL_DIR" || ! -f "$KERNEL_DIR/Makefile" ]]; then
  echo "Could not locate the extracted Linux source tree." >&2
  exit 1
fi

CONFIG_FILE="$(find /boot -maxdepth 1 -type f -name 'config-*' | sort -V | tail -n 1)"
if [[ -n "$CONFIG_FILE" ]]; then
  cp "$CONFIG_FILE" "$KERNEL_DIR/.config"
else
  make -C "$KERNEL_DIR" x86_64_defconfig
fi

cd "$KERNEL_DIR"
scripts/config --enable MODULES \
  --enable BLK_DEV_INITRD \
  --enable DEVTMPFS --enable DEVTMPFS_MOUNT \
  --enable BLK_DEV_LOOP --enable BLK_DEV_DM \
  --enable SQUASHFS --enable SQUASHFS_XZ \
  --enable OVERLAY_FS \
  --enable ISO9660_FS --enable UDF_FS \
  --enable EXT4_FS --enable VFAT_FS \
  --enable EFI --enable EFI_STUB \
  --enable USB --enable USB_XHCI_HCD --enable USB_EHCI_HCD --enable USB_STORAGE \
  --enable HID --enable HID_GENERIC --enable INPUT_EVDEV \
  --enable DRM --enable DRM_I915 --enable DRM_AMDGPU --enable DRM_NOUVEAU \
  --enable SOUND --enable SND_HDA_INTEL \
  --disable DEBUG_INFO --disable DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT \
  --disable DEBUG_INFO_DWARF5 --disable DEBUG_INFO_BTF \
  --disable MODULE_SIG --disable MODULE_SIG_ALL \
  --disable LOCALVERSION_AUTO \
  --set-str LOCALVERSION "-vulkanos" \
  --set-str SYSTEM_TRUSTED_KEYS "" \
  --set-str SYSTEM_REVOCATION_KEYS ""

make olddefconfig

# Linux 6.12's helper mkdebian emits debhelper-compat (= 12), which is
# unavailable on Debian 13 (Trixie). Trixie ships debhelper compat level 13.
# Adjust only the generated package metadata; the kernel source/config stay intact.
sed -i 's/debhelper-compat (= 12)/debhelper-compat (= 13)/' scripts/package/mkdebian
grep -q 'debhelper-compat (= 13)' scripts/package/mkdebian

KERNEL_VERSION="$(make -s kernelversion)"
cp .config "$ROOT/KERNEL-CONFIG"
cp "$SOURCE_ARCHIVE" "$ROOT/KERNEL-SOURCE.tar.xz"

grep -q '^CONFIG_BLK_DEV_INITRD=y$' .config
grep -q '^CONFIG_SQUASHFS=y$' .config
grep -q '^CONFIG_OVERLAY_FS=y$' .config

make -j"$(nproc)" bindeb-pkg LOCALVERSION=-vulkanos KDEB_PKGVERSION=0.3.0-1

mapfile -t IMAGE_PACKAGES < <(find "$WORK" -maxdepth 1 -type f -name 'linux-image-*.deb' ! -name '*-dbg*' | sort -V)
if (( ${#IMAGE_PACKAGES[@]} != 1 )); then
  echo "Expected exactly one custom kernel image package, found ${#IMAGE_PACKAGES[@]}." >&2
  printf '%s\n' "${IMAGE_PACKAGES[@]}" >&2
  exit 1
fi

PACKAGE_NAME="$(dpkg-deb -f "${IMAGE_PACKAGES[0]}" Package)"
case "$PACKAGE_NAME" in
  linux-image-*-vulkanos) ;;
  *) echo "Unexpected custom kernel package name: $PACKAGE_NAME" >&2; exit 1 ;;
esac

cp "${IMAGE_PACKAGES[0]}" "$OUT/"
dpkg-deb -f "$OUT/$(basename "${IMAGE_PACKAGES[0]}")" Package Version Architecture
echo "VULKANOS_KERNEL_RELEASE=$KERNEL_VERSION-vulkanos"
echo "VULKANOS_KERNEL_PACKAGE=$PACKAGE_NAME"
