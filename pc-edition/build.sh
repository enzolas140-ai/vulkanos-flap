#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")"

if [[ "$(id -u)" -ne 0 ]]; then
  echo "Run this build inside Debian 13 as root (for example: sudo bash build.sh)." >&2
  exit 1
fi

chmod +x config/hooks/normal/*.hook.chroot

lb config \
  --distribution trixie \
  --architectures amd64 \
  --binary-images iso-hybrid \
  --archive-areas "main contrib non-free non-free-firmware" \
  --debian-installer live \
  --bootappend-live "boot=live components quiet splash username=vulkan hostname=vulkanos locales=pt_BR.UTF-8 keyboard-layouts=br" \
  --iso-application "VulkanOS PC Edition" \
  --iso-publisher "VulkanOS Project" \
  --iso-volume "VULKANOS_PC_A01" \
  --apt-recommends false \
  --firmware-chroot true \
  --firmware-binary true

lb build

ISO="live-image-amd64.hybrid.iso"
test -s "$ISO"
mv "$ISO" "VulkanOS-PC-Alpha-0.1-amd64.iso"
sha256sum "VulkanOS-PC-Alpha-0.1-amd64.iso" > SHA256SUMS
ls -lh "VulkanOS-PC-Alpha-0.1-amd64.iso" SHA256SUMS