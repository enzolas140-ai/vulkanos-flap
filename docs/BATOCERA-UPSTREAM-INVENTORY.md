# Batocera upstream integration inventory

**Target:** VulkanOS PC Edition (amd64)  
**Reviewed Batocera source revision:** `c09342b99da6a76f51fe8527cc6053c7481e420b`  
**Review policy:** use source recipes, patches, emulator settings and system definitions as technical references; rebuild for Debian 13 instead of transplanting Buildroot binaries.

## Initial Debian-native emulator set

| VulkanOS ROM folder | System | Core | Debian package |
|---|---|---|---|
| `~/ROMs/nes` | NES | Nestopia | `libretro-nestopia` |
| `~/ROMs/snes` | SNES | Snes9x | `libretro-snes9x` |
| `~/ROMs/gb` | Game Boy | Gambatte | `libretro-gambatte` |
| `~/ROMs/gbc` | Game Boy Color | Gambatte | `libretro-gambatte` |
| `~/ROMs/gba` | Game Boy Advance | mGBA | `libretro-mgba` |
| `~/ROMs/megadrive` | Mega Drive / Genesis | Genesis Plus GX | `libretro-genesisplusgx` |

The Debian Trixie package repository confirms these cores. Genesis Plus GX and Snes9x are marked non-free; their current license terms and redistribution conditions must be reviewed before distributing the binaries in a public ISO.

## Batocera source areas reviewed

- Emulator build recipes and patches: https://github.com/batocera-linux/batocera.linux/tree/c09342b99da6a76f51fe8527cc6053c7481e420b/package/batocera/emulators
- Controller packages: https://github.com/batocera-linux/batocera.linux/tree/c09342b99da6a76f51fe8527cc6053c7481e420b/package/batocera/controllers
- EmulationStation integration: https://github.com/batocera-linux/batocera.linux/tree/c09342b99da6a76f51fe8527cc6053c7481e420b/package/batocera/emulationstation
- Per-system compatibility and emulator definitions: https://github.com/batocera-linux/batocera.linux/blob/c09342b99da6a76f51fe8527cc6053c7481e420b/package/batocera/emulationstation/batocera-es-system/systems-explanations.yml
- Batocera-maintained EmulationStation: https://github.com/batocera-linux/batocera-emulationstation

## Integration rules

1. Record the exact upstream revision, directory and patch before adapting any recipe.
2. Preserve upstream notices and package-specific license terms.
3. Rebuild for Debian's libraries and ABI, or use the Debian package when it is suitable.
4. Do not bundle ROMs, proprietary BIOS files, encryption keys or copyrighted game content.
5. A visible frontend is not proof that an emulator works. Acceptance means launching a legally obtained test ROM, verifying video/audio/input, saving and restoring state, exiting, and returning to the VulkanOS dashboard.

## Current boundary

This is a first-wave Debian-native libretro integration informed by Batocera's package organization and system definitions. It does not claim support for every Batocera platform, Dolphin, PCSX2, MAME, PPSSPP or every controller model. Those require separate packaging, licensing, hardware and performance tests.
