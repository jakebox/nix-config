{ config, pkgs, lib, ... }:

{
  _module.args.mainSSHKey = "prism-key";
  _module.args.username = "jacob";
  _module.args.email = "jacobboxerman@gmail.com";

  imports = [
    ./common.nix
    ./modules/browser.nix
    ./modules/taskwarrior.nix
    ./modules/vscode.nix
  ];

  home.homeDirectory = "/Users/jacob";

  home.sessionVariables = lib.mkForce {
    NIXCONFIG_DIR = "${config.home.homeDirectory}/home/nix-config";
  };

  home.packages = with pkgs; [
    taskwarrior3
    neovide
    hackrf
    claude-code
    gnuradio
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

  home.file.".claude/settings.json".text = ''
    {
      "env": {
        "ANTHROPIC_BASE_URL": "https://api.deepseek.com/anthropic",
        "ANTHROPIC_AUTH_TOKEN": "",
        "ANTHROPIC_TIMEOUT_MS": "600000",
        "ANTHROPIC_MODEL": "deepseek-chat",
        "ANTHROPIC_SMALL_FAST_MODEL": "deepseek-chat",
        "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1"
      }
    }
  '';

  programs.ssh.matchBlocks = {
    "ixion" = {
      hostname = "5.161.250.109";
      user = "beerbelly";
      identityFile = "%d/.ssh/beerbelly-key";
    };
  };

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
