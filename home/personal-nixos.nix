{ config, pkgs, ... }:

{
  _module.args.mainSSHKey = "butane-key";
  _module.args.username = "jacob";
  _module.args.email = "jacobboxerman@gmail.com";

  imports = [
    ./common.nix
    ./modules/browser.nix
  ];

  home.homeDirectory = "/home/${config._module.args.username}";

  home.packages = [
    pkgs.emacs30
    pkgs.firefox
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
