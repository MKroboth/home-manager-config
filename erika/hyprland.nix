{ ... }:
{
  wayland.windowManager.hyprland.settings = {

    monitor = [
      "eDP-1,highres,auto,1"
    ];
    xwayland = {
      force_zero_scaling = true;
    };
    gestures = {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more
      workspace_swipe = true;
    };
  };
}
