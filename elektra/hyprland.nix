{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "~/bin/video-wallpapers.sh"
      "dex -a"
      "eww --force-wayland open left-bar"
      "eww --force-wayland open right-bar"
      "eww --force-wayland open middle-bar"
    ];

    monitor = [
      "DP-3,1920x1080@60,0x0,1"
      "DP-2,2560x1440@166,1920x0,1"
      "DP-1,1920x1080@60,4480x0,1"
    ];

    input.numlock_by_default = true;

    general = {
      gaps_in = 0;
      gaps_out = 0;
      border_size = 1;
    };

    decoration = {
      rounding = 0;
    };

    misc = {
    };

  };
}
