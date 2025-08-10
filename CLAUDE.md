# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is **Everland**, a personal NixOS configuration using Flakes and Home Manager. It provides a complete desktop environment setup with Hyprland window manager, themed with Everforest, and includes comprehensive development tools and applications.

## Development Commands

### Core Operations
```bash
# Build and apply Home Manager configuration
make update

# Build configuration without applying
make build

# Clean old generations and garbage collect
make clean

# Generate hardware configuration (NixOS installation only)
make nixos-config

# Check flake syntax and build
nix flake check

# Update flake inputs
nix flake update

# Show flake outputs
nix flake show
```

### System Operations
```bash
# Apply NixOS system configuration (requires sudo)
sudo nixos-rebuild switch --flake .#fm39hz-desktop

# Test NixOS configuration without switching
sudo nixos-rebuild test --flake .#fm39hz-desktop

# Show system generations
nix profile history
```

## Architecture Overview

### Flake Structure
- **flake.nix**: Main flake configuration defining inputs (nixpkgs, home-manager, stylix, community flakes) and outputs
- **configuration.nix**: NixOS system-level configuration (bootloader, networking, users, services)
- **home.nix**: Home Manager entry point that imports modular configurations
- **hardware-configuration.nix**: Generated hardware-specific settings (filesystems, boot, drivers)

### Module Organization

**Desktop Environment** (`modules/desktop/`):
- `default.nix`: Imports theming and Hyprland modules
- `stylix.nix`: Hybrid Stylix + custom theming (recommended approach)
- `hyprland/`: Modular Hyprland configuration split across multiple files
  - `default.nix`: Main Hyprland config with plugins and packages
  - Individual files for keybinds, monitor, animations, decoration, etc.

**Program Configurations** (`programs/`):
- `default.nix`: Imports all program modules
- Organized by category: `browsers/`, `development/`, `media/`, `shells/`, `terminal/`
- Each module handles specific application configurations (git, shells, browsers, etc.)

### Key Configuration Patterns

**Personal Configuration**: User-specific settings defined in `flake.nix`:
```nix
personal = {
  city = "Hanoi";
  user = "fm39hz"; 
  hostname = "fm39hz-desktop";
  timeZone = "Asia/Ho_Chi_Minh";
  defaultLocale = "en_US.UTF-8";
  homeDir = "/home/${personal.user}";
};
```

**Community Flakes Integration**: Additional applications via community flakes:
- `zen-browser`: Modern Firefox-based browser
- `thorium-browser`: Performance-optimized Chromium
- `spicetify-nix`: Spotify theming and extensions

**Theme System**: Uses Stylix for system-wide theming with Everforest colorscheme

## Special Considerations

### Session Management
- Uses **UWSM** (Universal Wayland Session Manager) instead of traditional display managers
- Greetd login manager configured to start Hyprland via UWSM
- Session command: `uwsm start -S hyprland-uwsm.desktop`

### Hyprland Configuration
- Modular approach with separate files for different aspects (keybinds, animations, etc.)
- External config files sourced from `~/.config/hypr/conf/` for complex rules and plugins
- Supports multiple plugins: xtra-dispatchers, hyprsplit, hyprspace

### Vietnamese Input Support
- fcitx5 input method configured for Vietnamese typing
- Locale settings configured for Vietnam region

### Hardware Considerations
- Mesa graphics drivers from unstable channel for better hardware support
- Steam and gaming support enabled
- Docker and virtualization configured
- Bluetooth and audio (PipeWire) enabled

## File Locations

- **Flake root**: `/home/fm39hz/Workspace/Personal/Dots/everland/`
- **User config path**: `~/.config/nix/everland/` (as referenced in documentation)
- **Hyprland config**: `~/.config/hypr/conf/` (for external rules and plugins)

When making changes, ensure consistency with the modular architecture and test with `nix flake check` before applying configurations.