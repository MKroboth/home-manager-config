{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    font = {
      name = "FiraCode";
    };
    shellIntegration = {
      enableZshIntegration = true;
    };
    enableGitIntegration = true;
    settings = {
      confirm_os_window_close = 0;

      # Liquid-glass: Hyprland blur does most of the work, so the in-window
      # alpha can sit fairly low without turning text muddy.
      background_opacity = 0.75;
      background = "#0a0a12";
      foreground = "#eaeaf0";

      selection_background = "#7aafff";
      selection_foreground = "#0a0a12";
      cursor = "#b8a4ff";
      cursor_shape = "beam";

      window_padding_width = 10;
      hide_window_decorations = "yes";
    };
  };
}
