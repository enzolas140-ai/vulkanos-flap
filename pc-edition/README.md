# VulkanOS PC Edition — Alpha 0.1

VulkanOS PC is a lightweight, x86-64 Debian 13 live system with an XFCE desktop and a console-style gaming setup.

## Included
- XFCE desktop, NetworkManager, Bluetooth and PipeWire audio
- Firefox ESR
- Steam installer and 32-bit Mesa/Vulkan runtime
- RetroArch plus starter Libretro cores
- ES-DE game library frontend (official Linux x64 AppImage)
- Hydra Launcher (latest official Linux amd64 .deb at build time)
- AntiMicroX for mapping gamepad buttons to keyboard/mouse
- Gamepad/USB storage support and common PC firmware

## Build
Run `bash build.sh` as root inside Debian 13 (Trixie) with the packages listed in the GitHub Actions workflow.

The workflow builds an ISO-hybrid image and uploads it as a GitHub Actions artifact.

## USB
Write the ISO to a USB stick with Rufus. For Debian live images, choose **DD mode** when Rufus asks. This Alpha is a live installer image; it is not a tested persistent USB installation.

## Game folders
The live user starts with:
- `~/ROMs/nes`, `~/ROMs/snes`, `~/ROMs/gb`, `~/ROMs/gbc`, `~/ROMs/gba`, `~/ROMs/megadrive`
- `~/Games/Downloads`, `~/Apps`, `~/Themes`

ES-DE uses the standard `~/ROMs` directory and scans supported game files automatically. Only add games you are legally entitled to use; no game files are bundled.

## Current Alpha limitations
- Target is **PC x86-64 (amd64)**, not ARM handhelds.
- Dual-disk BOOT/VKROMS partition automation and the RUNVK storage wizard are not implemented yet. The current build does not repartition or format drives.
- Gamepad detection relies on Linux/SDL/Steam device rules; AntiMicroX provides manual keyboard/mouse mapping. Hardware testing is still required.
- Steam completes its client setup on first launch and needs internet access.

## Safety
The installer must never be pointed at a disk containing data you want to keep. Back up important files before installing. The build process itself does not touch local disks or USB devices.