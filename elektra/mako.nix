{ ... }:

{
  services.mako = {
    enable = true;
    settings = {
      # Match the eww control-center notification cards.
      font = "FiraCode Nerd Font Propo 11";
      width = 380;
      height = 120;
      margin = 10;
      padding = 12;
      border-size = 1;
      border-radius = 14;
      default-timeout = 6000;
      ignore-timeout = 1;
      max-history = 50;
      layer = "overlay";
      anchor = "top-right";

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

      "mode=do-not-disturb" = {
        invisible = 1;
      };
    };
  };
}
