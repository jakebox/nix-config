# mac-configuration.nix
{ pkgs
, lib
, self
, ...
}:
{

  fonts.packages = [
    pkgs.jetbrains-mono
  ];

  # Nix Darwin Options

  system = {
    primaryUser = "jacob";

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };

    defaults = {

      NSGlobalDomain = {
        NSAutomaticCapitalizationEnabled = false;
        ApplePressAndHoldEnabled = false; # Disable hold for accent
        InitialKeyRepeat = 13;
        AppleInterfaceStyle = "Dark";
        KeyRepeat = 2;
      };

      trackpad.Clicking = true;

      controlcenter = {
        BatteryShowPercentage = true;
      };

      screencapture.location = "/Users/jacob/home/";

      finder = {
        NewWindowTarget = "Other";
        NewWindowTargetPath = "file:///Users/jacob/home/";
        _FXSortFoldersFirst = true;
        FXDefaultSearchScope = "SCcf"; # Search current folder by default
        FXPreferredViewStyle = "clmv"; # Default column view
        ShowPathbar = true;
      };
      WindowManager.EnableStandardClickToShowDesktop = false;

      dock = {
        show-recents = false;
        autohide-time-modifier = 0.2;
        autohide = true;
        show-process-indicators = false;
        launchanim = false;
        tilesize = 72;
        persistent-apps = [
          { app = "/Applications/Firefox.app"; }
          { app = "/Applications/Google\ Chrome.app"; }
          { app = "/Applications/iTerm.app"; }
        ];
      };
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
}
