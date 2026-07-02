{ config, pkgs, ... }:

{
  _module.args.mainSSHKey = "lanolin-key";

  imports = [
    ./common.nix
    ./modules/ssh-identities.nix
  ];

  home.sessionVariables = {
    NIXCONFIG_DIR = "${config.home.homeDirectory}/nix-config";
  };

  home.packages = [
    pkgs.emacs30
    pkgs.tree
    pkgs.restic
    pkgs.nix-output-monitor
    pkgs.claude-code
  ];

  programs.zsh = {
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake $NIXCONFIG_DIR/.#lanolin";
    };
  };
  programs.starship = {
    enable = true;
    settings = {
      hostname = {
        ssh_only = false;
      };
    };
  };

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
