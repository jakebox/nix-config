# Common home-manager configurations
# Contains options common to any host, such as editor and shell configurations.

{ config, pkgs, mainSSHKey, lib, ... }:

let
  username = config._module.args.username;
  email = config._module.args.email;
in
{
  _module.args.username = lib.mkDefault "jacob";
  _module.args.email = lib.mkDefault "jacobboxerman@gmail.com";

  home.username = username;
  home.homeDirectory = lib.mkDefault "/home/${username}";

  home.packages = with pkgs; [
    direnv
    fd
    fzf
    htop
    btop
    lazygit
    nixpkgs-fmt
    nnn
    ripgrep
    zoxide
    tmux
    zellij
    rsync
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    extraConfig = ''
      set number
    '';
  };

  programs.git = {
    enable = true;
    ignores = [ "justfile" ".DS_Store" ];
    signing.signByDefault = true;
    signing.key = "${config.home.homeDirectory}/.ssh/${mainSSHKey}";
    settings = {
      user = {
        name = "Jacob Boxerman";
        email = email;
      };
      gpg.format = "ssh";
    };
  };

  programs.ssh.enable = true;
  programs.ssh.enableDefaultConfig = false;

  programs.ssh.matchBlocks = {
    "*" = {
      serverAliveInterval = 60;
      serverAliveCountMax = 3;
      addKeysToAgent = "yes";
      identitiesOnly = true;
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    loginExtra = ''echo -n "$USER @ " && uname -nmsr'';
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
      ];
    };
    completionInit = ''
      autoload -U compinit
      if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
        compinit
      else
        compinit -C
      fi
    '';
    shellAliases = {
      lg = "lazygit";
      gst = "git status";
      la = "ls -a";
      e = "emacsclient -c -nw";
      edaemon = "emacs --bg-daemon -nw";
    };
  };

  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;

  home.file = {
    ".config/emacs/init.el" = {
      source = ../emacs/init.el;
    };
    ".config/emacs/early-init.el" = {
      source = ../emacs/early-init.el;
    };
    ".config/emacs/programming.el" = {
      source = ../emacs/programming.el;
    };
    ".config/emacs/straight/versions/straight.lockfile.default.el" = {
      source = ../emacs/straight.lockfile.default.el;
    };
    ".config/emacs/straight/versions/straight.lockfile.programming.el" = {
      source = ../emacs/straight.lockfile.programming.el;
    };
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    prefix = "C-Space";
    extraConfig = "
    bind | split-window -h
    bind - split-window -v
    unbind '\"'
    unbind %
    ";
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.prefix-highlight;
        extraConfig = "set -g @plugin 'tmux-plugins/tmux-prefix-highlight'
        set -g status-right '#{prefix_highlight} | %a %Y-%m-%d %H:%M'";
      }
    ];
  };

}
