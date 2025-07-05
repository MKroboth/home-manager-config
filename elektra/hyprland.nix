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

    monitor =
      let
        colorManagement = "auto";
        sdrBrightness = "1.2";
        sdrSaturation = "1.5";
        qhdScaling = "auto";
        fhdScaling = "auto";
        vrrMode = "0";
      in
      [
        "DP-3,2560x1440@166,-2560x0,${qhdScaling}, cm, ${colorManagement}, sdrbrightness, ${sdrBrightness}, sdrsaturation, ${sdrSaturation}, vrr, ${vrrMode}"
        "DP-6,1920x1080@60,-1920x-1080,${fhdScaling}"

        "DP-2,2560x1440@166,0x0,${qhdScaling}, cm, ${colorManagement}, sdrbrightness, ${sdrBrightness}, sdrsaturation, ${sdrSaturation}, vrr, ${vrrMode}"
        "DP-5,1920x1080@60,0x-1080,${fhdScaling}"

        "DP-1,2560x1440@166,2560x0,${qhdScaling}, cm, ${colorManagement}, sdrbrightness, ${sdrBrightness}, sdrsaturation, ${sdrSaturation}, vrr, ${vrrMode}"
        "DP-4,1920x1080@60,1920x-1080,${fhdScaling}"
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

    render = {
      cm_fs_passthrough = true;
    };

    experimental = {
      xx_color_management_v4 = true;
    };

  };
}
