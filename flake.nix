{
  description = "Jacob's Flake.nix";

  inputs = {

    # Nix-Darwin Flake Inputs ---------
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager-darwin = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    # homebrew
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-emacs-plus = {
      url = "github:d12frosted/homebrew-emacs-plus";
      flake = false;
    };

    # NixOS Flake Inputs ---------
    home-manager-nixos = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    vscode-server.url = "github:nix-community/nixos-vscode-server";

    # nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs:
    {
      nixosConfigurations = {
        # $ sudo nixos-rebuild switch --flake .#butane
        butane = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./systems/xps-hardware-configuration.nix
            ./systems/xps-configuration.nix
            inputs.nixos-hardware.nixosModules.dell-xps-13-9380
            inputs.home-manager-nixos.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jacob = import ./home/personal-nixos.nix;
            }
          ];
        };
      };

      # $ darwin-rebuild build --flake .#prism
      darwinConfigurations = {
        "prism" = inputs.nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit (inputs) self homebrew-core homebrew-cask homebrew-emacs-plus;
          };

          modules = [
            ./systems/mac-configuration.nix
            inputs.home-manager-darwin.darwinModules.home-manager
            inputs.nix-homebrew.darwinModules.nix-homebrew
            {
              users.users.jacob = {
                name = "jacob";
                home = "/Users/jacob";
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jacob = import ./home/personal-mac.nix;
              nixpkgs.overlays = [
                (final: prev: { claude-code = (import inputs.nixpkgs-unstable { system = final.system; config.allowUnfree = true; }).claude-code; })
              ];
            }
          ];
        };
      };

      # $ home-manager switch --flake .#ubuntu-vm
      homeConfigurations = {
        "ubuntu-vm" = inputs.home-manager-nixos.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages."aarch64-linux";
          modules = [
            ./home/ubuntu-vm.nix
          ];
        };
      };
    };
}
