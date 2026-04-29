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
    pkgs.ghostty
  ];

  programs.zsh = {
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake $NIXCONFIG_DIR/.#butane";
    };
  };

  programs.ssh.matchBlocks = {
    "ixion" = {
      hostname = "5.161.250.109";
      user = "ixion";
      identityFile = "%d/.ssh/beerbelly-key";
    };
  };

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
