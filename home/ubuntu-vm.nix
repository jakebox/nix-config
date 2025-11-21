{ config, pkgs, ... }:

{
  _module.args.mainSSHKey = "ubuntu-vm-key";
  _module.args.username = "jacob";
  _module.args.email = "jib2137@columbia.edu";

  imports = [
    ./common.nix
    ./modules/browser.nix
  ];

  home.homeDirectory = "/home/${config._module.args.username}";

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
