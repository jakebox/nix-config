{ config, pkgs, lib, ... }:

{
  _module.args.mainSSHKey = "prism-key";

  imports = [
    ./common.nix
    ./modules/ssh-identities.nix
    ./modules/browser.nix
    ./modules/taskwarrior.nix
    ./modules/vscode.nix
  ];

  home.homeDirectory = "/Users/jacob";

  home.sessionVariables = {
    NIXCONFIG_DIR = "${config.home.homeDirectory}/home/nix-config";
  };

  services.syncthing = {
    enable = true;
    settings = {
      devices."server" = {
        id = "MX2IJ3Q-MNL2MLT-RCQB5GY-43JUDAY-67NXICA-ZMS73F4-BIOY4C4-EQW4UAK";
      };
      folders."core" = {
        path = "${config.home.homeDirectory}/home/core";
        devices = [ "server" ];
        versioning = {
          type = "staggered";
        };
      };
    };
  };

  home.packages = with pkgs; [
    taskwarrior3
    neovide
    claude-code
    taskwarrior-tui
    gh
  ];

  programs.zsh = {
    shellAliases = {
      nrb = "sudo darwin-rebuild switch --flake $NIXCONFIG_DIR/.#prism";
      tj = "task j";
    };
    initContent = ''
      # Override cd
      function cd() {
        if [[ $# -eq 0 ]]; then
          builtin cd "/Users/jacob/home"
        else
          builtin cd "$@"
        fi
      }

      # Only change directory if we're in the default home directory
      # and not already in a subdirectory (preserves editor terminal behavior)
      if [[ "$PWD" == "$HOME" && -z "$VSCODE_INJECTION" ]]; then
        if [[ -d "$HOME/home" ]]; then
          cd "$HOME/home"
        fi
      fi
    '';
  };

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
