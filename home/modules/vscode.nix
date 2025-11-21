{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = false;
    profiles.default = {
      userSettings = {
        "workbench.sideBar.location" = "right";
        "editor.minimap.enabled" = false;
        "window.commandCenter" = false;
        "workbench.layoutControl.enabled" = false;
        "chat.commandCenter.enabled" = false;
        "workbench.activityBar.location" = "hidden";
        "workbench.statusBar.visible" = false;
      };
    };
  };
}
