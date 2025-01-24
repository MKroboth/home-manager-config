{ ... }:
{
  wayland.windowManager.hyprland = {
    exec-once = [
      "~/bin/video-wallpapers.sh"
      "dex -a"
      "eww --force-wayland open left-bar"
      "eww --force-wayland open right-bar"
      "eww --force-wayland open middle-bar"
    ];

    monitor = [
      "DP-3,1920x1080@60,0x0,1"
      "DP-2,1920x1080@60,1920x0,1"
      "DP-1,1920x1080@60,3840x0,1"
    ];

    input.numlock_by_default = true;
  };
}
