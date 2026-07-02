{ config, pkgs, ... }:

{
  _module.args.mainSSHKey = "butane-key";

  imports = [
    ./common.nix
    ./modules/ssh-identities.nix
    ./modules/browser.nix
  ];

  home.sessionVariables = {
    NIXCONFIG_DIR = "${config.home.homeDirectory}/nix-config";
  };

  home.packages = [
    pkgs.emacs30
    pkgs.ghostty
  ];

  programs.zsh = {
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake $NIXCONFIG_DIR/.#butane";
    };
  };

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
