# Nix Configuration

This is my Nix configuration using Nix flakes fof for macOS, NixOS, and Linux environments.

It also includes my daily driver Emacs configuration.

## Overview

This repository contains Nix configurations for multiple systems:
- **macOS** (Darwin) - "prism" configuration
- **NixOS** - "butane" configuration (Dell XPS 13 9380)
- **Linux** - "ubuntu-vm" configuration (Home Manager only)

## System Configurations

- Target System: Apple Silicon Mac. Uses Nix-Darwin. GUI applications are installed with nix-homebrew.
- Target System: Dell XPS 13 9380 running NixOS.
- Target System: Ubuntu VM (Home Manager only)

## Project Structure

```
├── flake.nix                 # Main flake configuration
├── systems/
│   ├── mac-configuration.nix          # macOS system configuration
│   ├── xps-configuration.nix          # NixOS system configuration
│   └── xps-hardware-configuration.nix # Dell XPS hardware config
├── home/
│   ├── personal-mac.nix      # personal Macbook Home Manager config
│   ├── personal-nixos.nix    # persoanl NixOS Home Manager config
│   ├── ubuntu-vm.nix         # Ubuntu VM Home Manager config
│   ├── common.nix            # Shared Home Manager configuration
│   └── modules/
│       ├── browser.nix       # firefox
│       ├── taskwarrior.nix   # taskwarrior
│       └── vscode.nix        # VS Code configuration
```

## Key Features

There are a few features that I am particularly pleased with.

- **Home manager module system**: a common configuration applies to most of the machines I use. Anything requiring some refined configuration gets added or overridden in a machine-specific file, which imports common.
- **SSH management**: Home manager is used to manage SSH configuration. A primary machine key name is an input to the common file.
- **Environment variables**: Configuration uses NIXCONFIG_DIR environment variable for easy path resolution on any machine.

## Emacs

My Emacs configuration is in this repo. Home manager places the configuration files as well as package lockfiles in their appropriate directories.

## Dependencies

### Flake Inputs
- nixpkgs (stable and unstable)
- nix-darwin (macOS system management)
- home-manager (user environment management)
- nix-homebrew (macOS package management)
- nixos-hardware (hardware-specific configurations)
