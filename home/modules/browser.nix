{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;

    profiles.default = {
      id = 0;
      isDefault = true;

      bookmarks.force = true;
      bookmarks.settings = [
        {
          name = "Gmail";
          url = "https://mail.google.com/mail/u/0/#inbox";
        }
        {
          name = "Github";
          url = "https://github.com/jakebox/";
        }
        {
          name = "Maps";
          url = "https://www.google.com/maps";
          keyword = "map";
        }
        {
          name = "Metrolink";
          url = "https://metrolinktrains.com/";
        }
        {
          name = "Peacock";
          url = "https://www.peacocktv.com/watch/home";
        }
        {
          name = "Garmin Connect";
          url = "https://connect.garmin.com/modern/home";
        }
        {
          name = "WhatsApp";
          url = "https://web.whatsapp.com/";
        }
        {
          name = "Finance";
          bookmarks = [
            {
              name = "Chase";
              url = "https://secure.chase.com/web/auth/dashboard";
            }
            {
              name = "Fidelity";
              url = "https://digital.fidelity.com/prgw/digital/login/full-page";
            }
            {
              name = "Discover";
              url = "https://www.discover.com/login/?Aff=Bank";
            }
          ];
        }
        {
          name = "LLMs";
          bookmarks = [
            {
              name = "gemini";
              url = "https://gemini.google.com/app";
            }
            {
              name = "chatgpt";
              url = "https://chatgpt.com/";
            }
            {
              name = "claude";
              url = "https://claude.ai/new";
            }
          ];
        }
        {
          name = "Nix";
          bookmarks = [
            {
              name = "nix-darwin";
              url = "https://nix-darwin.github.io/nix-darwin/manual/";
            }
            {
              name = "home-manager";
              url = "https://home-manager-options.extranix.com/";
            }
            {
              name = "nixpkgs";
              url = "https://search.nixos.org/packages";
            }
            {
              name = "nix options";
              url = "https://search.nixos.org/options";
            }
          ];
        }
        {
          name = "Website";
          bookmarks = [
            {
              name = "Search console";
              url = "https://search.google.com/search-console/performance/search-analytics?resource_id=https%3A%2F%2Fjakebox.github.io%2F";
            }
            {
              name = "Analytics";
              url = "https://analytics.google.com/analytics/web/#/a368252691p504873477/reports/intelligenthome";
            }
          ];
        }
        {
          name = "Misc";
          bookmarks = [
            {
              name = "Liondine";
              url = "https://liondine.com/";
            }
            {
              name = "Beerbelly";
              url = "https://beerbellyapp.com/";
            }
          ];
        }
      ];
      # Set preferences
      settings = {
        # Compact mode
        "browser.uidensity" = 1;

        "browser.warnOnQuit" = false;

        # Search bar
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.suggest.bookmark" = true;
        "browser.urlbar.suggest.recentsearches" = false;

        # Toolbar
        "identity.fxaccounts.toolbar.enabled" = false;

        # Delete key goes back
        "browser.backspace_action" = 0;

        # Privacy
        "privacy.trackingprotection.enabled" = true;
        "privacy.globalprivacycontrol.enabled" = true;
        "signon.rememberSignons" = false;

        # Disable sidebar
        "browser.sidebar.enabled" = false;
        "browser.sidebar.position_start" = false;
        "sidebar.revamp" = false;

        # Set startup homepage to new tab
        "browser.startup.page" = 3; # 3 = restore previous session, 0 = blank, 1 = homepage
        "browser.startup.homepage" = "about:newtab";

        # Clean new tab (search bar only)
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.snippets" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = true;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
        "browser.newtabpage.activity-stream.showTopSites" = false;
        "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
        "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
        "browser.newtabpage.activity-stream.showSearch" = true;
        "browser.newtabpage.enabled" = true;
      };
      extensions = [ ];
    };
  };
}
