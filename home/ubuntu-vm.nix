{ config, pkgs, ... }:

{
  _module.args.mainSSHKey = "ubuntu-vm-key";
  _module.args.email = "jib2137@columbia.edu";

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
  ];

  programs.zsh = {
    shellAliases = {
      hms = "home-manager switch --flake $NIXCONFIG_DIR/.#ubuntu-vm";
    };
  };

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
