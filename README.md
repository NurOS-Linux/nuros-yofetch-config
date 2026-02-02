# NurOS YoFetch Configuration

Official YoFetch configuration for NurOS - the FRESH operating system.

## FRESH Philosophy

**F**riendly for User  
**R**esource-efficient  
**E**asy, but not too much  
**S**ource (Free/Libre Open Source Software)  
t**H**inking different

## About NurOS

NurOS is an independent, rolling-release Linux distribution designed as a universal, better alternative to Windows. Drawing inspiration from Fedora, Mint, and NixOS, NurOS combines user-friendliness with resource efficiency while maintaining the flexibility that power users demand.

## Features

### Minimal Information Display
Following the FRESH philosophy, shows only essential information:
- **OS**: NurOS (rolling release, no version number needed)
- **Kernel**: Linux kernel version
- **Uptime**: System uptime in human-readable format
- **Packages**: Smart package count with manager detection
- **Shell**: Current shell with version
- **DE**: Desktop Environment (auto-detected, falls back to WM or TTY)
- **Terminal**: Terminal emulator (auto-detected)

### Package Manager Detection

The configuration intelligently detects package counts:

1. **Primary**: Tries `tulpar list --count` (NurOS native package manager)
2. **Fallback**: If tulpar is not available (demo/development), detects and counts packages from:
   - pacman (Arch-based)
   - apt (Debian-based)
   - dnf (Fedora-based)
   - nix (Nix packages)
   - flatpak (Universal packages)

This allows the configuration to work on development systems before tulpar is ready.

### Beautiful Separator
Uses `▸` symbol in cyan as a stylish, minimal separator between labels and values.

### Auto-Detection
- **Desktop Environment**: Checks `$XDG_CURRENT_DESKTOP`, falls back to `$DESKTOP_SESSION`, then WM detection
- **Window Manager**: Uses `wmctrl` if no DE is found
- **Terminal**: Detects parent process to identify terminal emulator
- **Shell Version**: Automatically fetches shell version information

## Color Scheme

- **Primary**: Blue (`{color.blue}`) - NurOS brand color
- **Accent**: Bright Blue (`{color.bright_blue}`) - Highlights
- **Separator**: Cyan (`{color.cyan}`) - Beautiful ▸ symbol
- **Logo Gradient**: Blue → Bright Blue → Cyan → Bright Cyan

## Customization

### Changing Colors
Edit the color variables at the top of `config.lua`:
```lua
local accent = "{style.bold}{color.blue}"     -- Label color
local bright = "{color.bright_blue}"          -- Highlight color
local sep = reset .. " {color.cyan}▸{style.reset} "  -- Separator
```

### Changing Layout
Modify the padding and mode:
```lua
yo.padding(3, 0, 1)  -- Right, Left, Top spacing
yo.mode("default")   -- "default" (horizontal) or "vertical"
```

### Adding/Removing Info Fields
Add new lines using the helper function:
```lua
yo.print(info_line("Label", "value"))
```

Or remove existing `yo.print()` calls you don't need.

### Modifying the Logo
Edit the `yo.logo()` section. You can change colors for each line or replace the entire ASCII art.

## Philosophy in Practice

This configuration embodies NurOS's FRESH principles:

- **Friendly for User**: Clean, readable output with auto-detection
- **Resource-efficient**: Minimal information, efficient commands, caching where needed
- **Easy, but not too much**: Simple structure, but customizable for power users
- **Source (FLOSS)**: Open configuration, hackable Lua code
- **tHinking different**: Independent approach with unique visual identity

## Technical Details

- **Language**: Lua (YoFetch configuration)
- **Dependencies**: bash, basic coreutils (uptime, uname, etc.)
- **Optional**: wmctrl (for WM detection)
- **Default Mode**: Horizontal (logo left, info right)
- **Shell**: /bin/bash with -c flag

## Files

- `config.lua` - Main YoFetch configuration (Lua)
- `README.md` - This file

## Acknowledgments

Special thanks to [m1lkydev](https://github.com/m1lkydev) for creating [YoFetch](https://github.com/m1lkydev/yofetch) - a highly configurable system information tool that makes this beautiful NurOS display possible.

## License

This configuration is part of the NurOS project and is licensed under the MIT License.
