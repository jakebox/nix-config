# mac-configuration.nix
{ pkgs
, lib
, self
, homebrew-core
, homebrew-cask
, homebrew-emacs-plus
, ...
}:
{
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    taps = [ "homebrew/cask" ];
    brews = [
      { name = "emacs-plus"; }
      { name = "soapyhackrf"; }
      { name = "soapysdr"; }
      { name = "scrcpy"; }
      { name = "mas"; } # CLI brew control, used by nix-homebrew
    ];
    casks = [
      "firefox"
      "balenaetcher"
      "iterm2"
      "rectangle"
      "flux-app"
      "slack"
      "zoom"
      "discord"
      "google-chrome"
      "calibre"
      "appcleaner"
      "visual-studio-code"
      "spotify"
      "android-file-transfer"
      "microsoft-word"
      "obs"
      "bambu-studio"
      "autodesk-fusion"
      "alt-tab"
      "imageoptim"
      "veracrypt"
      "arduino-ide"
      "vlc"
      "xournal++"
      "tailscale-app"
      "cloudflare-warp"
      "android-platform-tools"
      "handbrake-app"
    ];
    masApps = {
      "copyclip" = 595191960;
    };
  };

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

  nix-homebrew = {
    enable = true;

    user = "jacob";

    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "d12frosted/homebrew-emacs-plus" = homebrew-emacs-plus;
    };
    mutableTaps = false;

  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
}
