# Common home-manager configurations
# Contains options common to any host, such as editor and shell configurations.

{ config, pkgs, mainSSHKey, username, email, lib, ... }:

{
  home = {
    username = username;
  };

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
    userName = "Jacob Boxerman";
    userEmail = email;
    ignores = [ "justfile" ".DS_Store" ];
    signing.signByDefault = true;
    signing.key = "${config.home.homeDirectory}/.ssh/${mainSSHKey}";
    extraConfig = {
      gpg.format = "ssh";
    };
  };

  programs.ssh.enable = true;

  home.sessionVariables = {
    NIXCONFIG_DIR = "${config.home.homeDirectory}/nix-config";
  };

  programs.ssh.matchBlocks = {
    "github github.com" = {
      hostname = "github.com";
      user = "git";
      identityFile = "%d/.ssh/${config._module.args.mainSSHKey}";
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
      tmuxPlugins.prefix-highlight
      {
        plugin = tmuxPlugins.prefix-highlight;
        extraConfig = "set -g @plugin 'tmux-plugins/tmux-prefix-highlight'
        set -g status-right '#{prefix_highlight} | %a %Y-%m-%d %H:%M'";
      }
    ];
  };

}
