# VulkanOS PC Edition — Alpha 0.1

VulkanOS PC is a lightweight, x86-64 Debian 13 live system with XFCE and an experimental console-style dashboard.

## Included
- XFCE desktop, NetworkManager, Bluetooth and PipeWire audio
- Experimental VulkanOS dashboard with a dark red/black console-style layout
- Dashboard pages for Library, Emulators, Browser, Steam, Settings and About
- Dashboard tiles for Steam, RetroArch, ES-DE, Hydra Launcher and Firefox ESR
- Basic listing of installed Steam games and ROM files found under ~/ROMs
- Basic system indicators for network, visible joystick devices, Bluetooth and battery
- Firefox ESR
- Steam installer and 32-bit Mesa/Vulkan runtime
- RetroArch plus starter Libretro cores
- ES-DE game library frontend (official Linux x64 AppImage)
- Hydra Launcher (latest official Linux amd64 .deb at build time)
- AntiMicroX for manual gamepad-to-keyboard/mouse mapping

The dashboard opens automatically after the XFCE session starts. It does not replace ES-DE: the dashboard opens ES-DE for the emulation library. Keyboard shortcuts are shown in the footer. Controller detection is only a basic device-presence indicator; universal gamepad navigation/mapping is not implemented yet.

## Build
Run bash build.sh as root inside Debian 13 (Trixie) with the packages listed in the GitHub Actions workflow.

The workflow builds an ISO-hybrid image and uploads it as a GitHub Actions artifact.

## USB
Write the ISO to a USB stick with Rufus. For Debian live images, choose DD mode when Rufus asks. Test the live session before installing. This is not a tested persistent USB installation.

## Game folders
The live user starts with:
- ~/ROMs/nes, ~/ROMs/snes, ~/ROMs/gb, ~/ROMs/gbc, ~/ROMs/gba, ~/ROMs/megadrive
- ~/Games/Downloads, ~/Apps, ~/Themes

ES-DE uses the standard ~/ROMs directory and scans supported game files automatically. Only add games you are legally entitled to use; no game files are bundled.

## Current Alpha limitations
- Target is PC x86-64 (amd64), not ARM handhelds.
- Dual-disk BOOT/VKROMS partition automation and the RUNVK storage wizard are not implemented. The current build does not repartition or format drives.
- Universal controller navigation and automatic controller mapping are not implemented. AntiMicroX provides manual mapping.
- The dashboard layout and hardware indicators have not yet been validated on a physical PC.
- Steam completes its client setup on first launch and needs internet access.

## Safety
The installer must never be pointed at a disk containing data you want to keep. Back up important files before installing. The build process itself does not touch local disks or USB devices.
