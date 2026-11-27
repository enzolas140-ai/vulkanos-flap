# VulkanOS RELEASE — Architecture and Batocera Integration

**Status:** approved project direction; implementation is incremental  
**Target covered here:** VulkanOS PC Edition, x86-64  
**Product identity:** VulkanOS is its own PC operating system and user experience. Batocera is an upstream technical reference and source of selected reusable components—not the product identity and not a drop-in replacement image.

## Product definition

VulkanOS RELEASE should boot as a complete PC operating system with:

1. A VulkanOS-branded BIOS/UEFI boot menu with **Live** and **Install** paths.
2. A white volcano mark during boot, gently pulsing and oscillating.
3. Direct entry into the Live session without a password prompt.
4. The VulkanOS full-screen dashboard as the main shell.
5. A gaming layer with a library frontend, emulators, controller setup, game launchers, saves, shaders and per-system settings.
6. Keyboard, mouse, USB gamepad and Bluetooth gamepad support through Linux input and application-level mappings.
7. A tested installer, recovery path, hardware detection and a documented third-party license inventory.

The PC release is x86-64. The handheld/RK3326 work based on ArkOS4Clone remains a separate architecture and build target.

## System architecture

### 1. Operating-system foundation

Keep Debian 13 (Trixie) as the initial PC base while the VulkanOS experience and gaming integration mature. Debian provides the PC package ecosystem, Steam dependencies, desktop applications and firmware integration already used by this project.

The VulkanOS kernel is a custom-configured and compiled Linux x86-64 kernel package. It is not a kernel written from scratch. It must retain the capabilities required by the Live environment (initramfs, loop devices, SquashFS, OverlayFS, USB, EFI, graphics, audio and storage). Kernel source, configuration, version and patches must accompany every distributable kernel build.

Do not reuse an ARM/RK3326 kernel for the x86-64 PC release.

### 2. VulkanOS user experience

The boot menu, Plymouth animation, login/session behavior, dashboard, visual identity, settings entry points and VulkanOS-specific utilities belong to this project.

The dashboard remains the top-level shell. Users should not be dropped into a generic desktop or a stock Batocera interface without choosing to open the relevant gaming frontend.

### 3. Gaming and emulation layer informed by Batocera

Use the public Batocera source tree as an engineering reference for package recipes, patches, emulator versions, launch commands, system definitions, controller behavior and configuration defaults.

Important upstream areas to inspect:

- `package/batocera/emulators/`: emulator package recipes, build flags, patches and install steps.
- `package/batocera/controllers/`: controller-related packages and support utilities.
- `package/batocera/emulationstation/`: EmulationStation integration, systems and web UI packages.
- `package/batocera/gpu/`, `package/batocera/audio/`, `package/batocera/network/`: hardware-related integration references.
- The upstream Buildroot configuration and board files: useful for understanding dependencies and per-platform selections.

**Do not copy Batocera's prebuilt binaries into Debian blindly.** Many are built against Batocera's Buildroot userspace and library versions. For the Debian-based VulkanOS image, prefer this order:

1. Use Debian packages when they provide a suitable and supported build.
2. Otherwise rebuild upstream emulator source for Debian x86-64, using relevant Batocera patches only after checking their provenance and license.
3. Preserve each emulator's required runtime libraries, firmware/BIOS expectations, configuration format and command-line options.
4. Add a VulkanOS launcher/wrapper that translates the selected system, ROM path and user configuration into the correct executable invocation.
5. Test each emulator independently before exposing it as a working dashboard tile.

### 4. Frontend and launch integration

The VulkanOS Dashboard is the main system interface. The emulation library can use EmulationStation (including the Batocera-maintained fork) or retain ES-DE where that is more practical.

The Batocera EmulationStation repository documents that running its frontend outside a Batocera-equivalent environment is barebones: emulator launching and some secondary functions will not work simply by compiling the UI. Therefore, adopting the frontend also requires implementing and maintaining the surrounding runtime:

- `es_systems.cfg` or the equivalent system definitions.
- ROM directory mappings and supported file extensions.
- Emulator launch commands and environment variables.
- Per-system emulator selection and options.
- BIOS/firmware validation messages without bundling restricted files.
- Save/state paths, screenshots, logs and per-user configuration.
- Exit handling that reliably returns to the VulkanOS Dashboard.

No frontend is considered integrated until a user can select a real test game, launch it, use controls and audio, exit it, and return to the VulkanOS interface.

### 5. Controller, keyboard and mouse layer

Use Linux input/udev and SDL controller support as the base. Study Batocera's controller packages, mappings and configuration flow, but maintain VulkanOS profiles and persistence.

Target behavior:

- First-run controller mapping wizard.
- Multiple controllers remembered independently.
- Generic HID, XInput-style, DirectInput-style, common USB and Bluetooth controllers where the Linux/SDL stack supports them.
- Keyboard and mouse support in the dashboard and in emulators.
- Per-emulator overrides and reset-to-default.
- Axis dead zones, analog sensitivity, trigger mapping and hotkeys.
- AntiMicroX as an optional fallback for manual gamepad-to-keyboard/mouse mapping.

Do not advertise universal compatibility. The exact controller, Bluetooth adapter, kernel driver, SDL version and emulator determine real support.

### 6. Graphics, audio and performance

For PC, use the normal Linux graphics stack and appropriate Mesa/Vulkan packages. Select drivers and firmware based on detected hardware rather than forcing one GPU driver on every machine. Keep PipeWire/ALSA integration and allow per-emulator audio configuration.

Performance features such as GameMode, MangoHud, shaders, Vulkan renderer options and frame pacing should be enabled only where the hardware and emulator support them. Do not make Vulkan mandatory for emulators that support OpenGL or software rendering only.

## Proposed implementation phases

### Phase A — Foundation and boot experience

- Make Live boot, installer entry, splash animation and dashboard startup reliable.
- Verify the custom x86-64 kernel boots the Live filesystem.
- Confirm wired/Wi-Fi networking, display, audio, storage and login behavior.
- Keep the installer opt-in and require explicit disk selection; never format a disk silently.

### Phase B — Batocera technical inventory

- Pin a Batocera source revision for each integration review.
- Inventory x86-64 emulator recipes and their build dependencies.
- Record source URL, version/commit, patches, package license and runtime dependencies.
- Select a small first batch of emulators that build cleanly on Debian.
- Create a compatibility report instead of assuming every Batocera-supported system will work.

### Phase C — VulkanOS Game Runtime

- Create system definitions and ROM folder conventions.
- Implement launch wrappers, exit handling, log capture and configuration paths.
- Integrate the selected library frontend with the runtime.
- Add controller wizard and persistent mapping profiles.
- Connect the library to the VulkanOS Dashboard.

### Phase D — Compatibility and performance

- Test each emulator on actual x86-64 hardware.
- Validate gamepad, keyboard/mouse, audio, video, save states and return-to-dashboard.
- Test Intel, AMD and NVIDIA graphics paths separately where hardware is available.
- Measure boot time, idle memory and frame pacing before applying optimizations.

### Phase E — Release readiness

- Test UEFI and legacy BIOS where supported, Live boot, installer and recovery.
- Verify updates, filesystem persistence and user-data backup.
- Publish ISO checksums, kernel version/config/source, build instructions and license notices.
- Keep the release marked Alpha/Beta until the physical hardware matrix passes.

## Licensing and attribution policy

Batocera is assembled from hundreds of upstream projects; its official license page describes a mixture of GPL, LGPL, BSD, MIT and other licenses, including non-commercial licenses. Batocera-authored code is generally LGPL-3.0 unless an upstream license applies. The Batocera-maintained EmulationStation repository reports MIT licensing.

VulkanOS must not replace or override upstream licenses with its own project license. For each imported or adapted component:

- Keep the original copyright and license notices.
- Preserve source availability and corresponding source/patches when the license requires it.
- Record the exact upstream commit/tag and any local modifications.
- Add an SPDX/license entry to a VulkanOS third-party manifest.
- Review non-commercial, proprietary, firmware and redistribution restrictions separately before including a binary in a public ISO.
- Do not distribute game ROMs, proprietary BIOS files, keys or copyrighted game content.

The existing VulkanOS custom evaluation license applies only to original VulkanOS materials. It does not relicense Debian, Linux, Batocera, EmulationStation or individual emulators.

## Initial upstream references

- Batocera main source: https://github.com/batocera-linux/batocera.linux
- Batocera emulator recipes: https://github.com/batocera-linux/batocera.linux/tree/master/package/batocera/emulators
- Batocera controller packages: https://github.com/batocera-linux/batocera.linux/tree/master/package/batocera/controllers
- Batocera EmulationStation source: https://github.com/batocera-linux/batocera-emulationstation
- Batocera compilation guide: https://wiki.batocera.org/compile_batocera.linux
- Batocera license guidance: https://wiki.batocera.org/license

## Current implementation state

This document records the approved architecture. It does not claim that the Batocera runtime, all emulators, universal controller support or a stable RELEASE image have already been implemented. The current PC branch contains the earlier VulkanOS boot/dashboard/kernel work; Batocera integration will be developed and validated in the phases above.
