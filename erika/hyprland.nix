{ ... }:
{
  wayland.windowManager.hyprland.settings = {

    monitor = [
      "eDP-1,1920x1080@60,0x0,1"
    ];
    gestures = {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more
      workspace_swipe = true;
    };

  };
}
