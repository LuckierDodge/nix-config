# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal Nix configuration repository managing system configurations across multiple machines using Nix flakes, NixOS, nix-darwin (macOS), and Home Manager. The repository supports hybrid Linux/macOS environments with declarative system and user configurations.

## System Update Commands

### NixOS Systems
```bash
# Apply system configuration for specific hosts
sudo nixos-rebuild switch --impure --flake .#aegis
sudo nixos-rebuild switch --impure --flake .#killingtime
sudo nixos-rebuild switch --impure --flake .#bigbox

# Build without switching (test configuration)
sudo nixos-rebuild build --impure --flake .#hostname
```

### macOS Systems (nix-darwin)
```bash
# Apply Darwin configuration
sudo darwin-rebuild switch --flake .#primemover
```

### Home Manager (Standalone)
```bash
# Apply user environment configurations
home-manager switch --flake .#luckierdodge@stark
home-manager switch --flake .#luckierdodge@lastprism
home-manager switch --flake .#luckierdodge@cerberus
```

### Development Commands
```bash
# Format all Nix files
nix fmt

# Check flake configuration
nix flake check

# Update flake inputs
nix flake update

# Garbage collection
nix-collect-garbage -d
sudo nix-collect-garbage -d  # NixOS systems
```

## Architecture Overview

### Flake Structure
- **flake.nix**: Main entry point defining all system configurations, inputs, and outputs
- **nixos/**: NixOS system configurations per machine
- **darwin/**: macOS nix-darwin configurations
- **home-manager/**: User environment configurations (can be standalone or integrated)
- **modules/**: Reusable modules for both NixOS and Home Manager
- **overlays/**: Package overlays and modifications
- **pkgs/**: Custom package definitions

### Configuration Pattern
The repository uses a modular approach where:
1. Each machine has its own configuration file (e.g., `nixos/aegis.nix`, `darwin/primemover.nix`)
2. Common base configurations are in `nixos/configuration.nix` and `home-manager/home.nix`
3. Machine-specific configurations import and extend the base configurations
4. Home Manager is integrated into system configurations for seamless user environment management

### Key Features
- **Multi-platform**: Supports both NixOS and macOS via nix-darwin
- **Secrets Management**: Uses sops-nix for encrypted secrets
- **Remote Development**: Includes VSCode Server configuration
- **Container Support**: Docker configuration with IPv6 support
- **Desktop Environment**: KDE Plasma 6 with Wayland support
- **Package Management**: Flatpak integration for GUI applications

### Machine Configurations
- **aegis**: x86_64-linux NixOS system
- **killingtime**: x86_64-linux NixOS system
- **bigbox**: x86_64-linux NixOS system
- **primemover**: aarch64-darwin macOS system
- **stark, lastprism, cerberus**: Home Manager only configurations

### Development Environment
The configuration includes development tools like:
- Git, GitHub CLI, Docker
- Programming languages (Node.js, Python, Haskell)
- Terminal tools (tmux, zsh, starship, fzf)
- Editors (Vim, VSCode)
- Claude Code CLI

When modifying configurations, always test with `nixos-rebuild build` or equivalent before switching to avoid breaking system state.
