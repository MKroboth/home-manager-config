{ ... }:

{
  services.mako = {
    enable = true;
    settings = {
      # Match the AGS control-center notification cards.
      font = "FiraCode Nerd Font Propo 10";
      width = 300;
      height = 80;
      margin = 8;
      padding = "8,12";
      border-size = 1;
      border-radius = 12;
      default-timeout = 6000;
      ignore-timeout = 1;
      max-history = 50;
      layer = "overlay";
      anchor = "top-right";
      output = "DP-2";

      background-color = "#0c0c12cc";
      border-color = "#ffffff1f";
      text-color = "#eaeaf0eb";
      progress-color = "over #7aafff66";

      icon-path = "/run/current-system/sw/share/icons";

      "urgency=low" = {
        border-color = "#ffffff1f";
        default-timeout = 4000;
      };

      "urgency=normal" = {
        border-color = "#7aafff59";
      };

      "urgency=high" = {
        border-color = "#ffa0c499";
        background-color = "#1a0c12dd";
        default-timeout = 0;
      };

      # Light mode — activated via `makoctl mode -a light` from apply-theme
      # when the system toggle flips. `makoctl mode -r light` reverts.
      "mode=light" = {
        background-color = "#fafafbcc";
        border-color = "#1a1a221f";
        text-color = "#1a1a22eb";
        progress-color = "over #3a6dd166";
      };

      "mode=light urgency=low" = {
        border-color = "#1a1a221f";
      };

      "mode=light urgency=normal" = {
        border-color = "#3a6dd159";
      };

      "mode=light urgency=high" = {
        border-color = "#c44850aa";
        background-color = "#fff0f2dd";
        text-color = "#1a1a22eb";
      };

      "mode=do-not-disturb" = {
        invisible = 1;
      };

      # Vesktop (Discord) titles include server + channel + sender, which
      # easily wraps past the default 80px height and hides the message body.
      "app-name=vesktop" = {
        width = 450;
        height = 220;
      };
    };
  };
}
