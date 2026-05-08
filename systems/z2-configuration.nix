# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  # Bootlader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "lanolin";

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jacob = {
    isNormalUser = true;
    extraGroups = [ "wheel" "filebrowser" ];
    shell = pkgs.zsh;
    hashedPassword = "$y$j9T$yhnph5fmv4egpuYLpEXST/$.smYXtndwrunKUMCpwveaAorZOD0j.vQjBPgdaJOhGC";
  };

  users.users.ixion = {
    isNormalUser = true;
    shell = pkgs.zsh;
    hashedPassword = "!";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILidWtddwo2F6aaEwTEFmGh33FCy9VVoDfheVqSnHmYD dylansatow531@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILN5HACeH+NgQ2Mwpz2WZcs7cMu17MoY8KV2o1gG33TL jacob@prism.local"
    ];
    extraGroups = [ "wheel" ];
    packages = with pkgs; [ vim neovim lazygit btop zellij ];
  };

  programs.zsh.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.tailscale.enable = true;

  services.syncthing = {
    enable = true;
    dataDir = "/home/jacob/";
    user = "jacob";
    guiAddress = "100.99.105.101:8384";
    settings = {
      devices = {
        "mac" = {
          id = "ZN6RW4V-G656XZ5-DMCXAUZ-OKSAJRE-CRGWNPK-5D2GWXW-CQGACHL-BSHAJQY";
        };
      };
      folders = {
        "core" = {
          path = "/data/core";
          devices = [ "mac" ];
        };
      };
    };
  };

  services.filebrowser = {
    enable = true;
    settings = {
      port = 8081;
      address = "100.99.105.101";
      root = "/data";
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}

