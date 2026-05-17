{ config, pkgs, ... }:

{
  _module.args.mainSSHKey = "lanolin-key";
  _module.args.username = "jacob";
  _module.args.email = "jacobboxerman@gmail.com";

  imports = [
    ./common.nix
  ];

  home.homeDirectory = "/home/${config._module.args.username}";

  home.packages = [
    pkgs.emacs30
    pkgs.tree
    pkgs.restic
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
