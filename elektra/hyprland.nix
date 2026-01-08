{ pkgs, ... }:
{
  systemd.user = {
    targets.hyprland = {
      Unit = {
        Description = "Hyprland Active";
        Requires = "graphical-session.target";
        After = "default.target";
      };
    };
    services.hyprsunset = {
      Unit = {
        Description = "Start hyprsunset";
      };
      Install = {
        WantedBy = [ "hyprland.target" ];
      };
      Service = {
        ExecStart = "${pkgs.hyprsunset}/bin/hyprsunset";
        Restart = "on-failure";
        RestartSec = 5;
        StartLimitBurst = 5;
      };
    };
  };
  wayland.windowManager.hyprland.settings = {
    "$fileManager" = "dolphin";
    exec-once = [
      "systemctl --user start hyprland.target"
      "systemctl --user start mako.service"
      "systemctl --user start blueman-applet.service"
      "hyprpaper"
      "~/bin/wallpapers.sh"
      "dex -a"
      "~/.config/eww/scripts/start-eww"
    ];

    monitor =
      let
        colorManagement = "auto";
        fourKcolorManagement = "wide";
        sdrBrightness = "1.2";
        sdrSaturation = "1.5";
        fourKScaling = "1.5";
        qhdScaling = "1";
        fhdScaling = "0.75";
        vrrMode = "0";
        fourKvrrMode = "1";
      in
      [
        "DP-3,2560x1440@166,0x1440,${qhdScaling}, cm, ${colorManagement}, sdrbrightness, ${sdrBrightness}, sdrsaturation, ${sdrSaturation}, vrr, ${vrrMode}"

        "DP-6,1920x1080@60,0x0,${fhdScaling}"

        "DP-2,3840x2160@166,2560x1440,${fourKScaling}, cm, ${fourKcolorManagement}, sdrbrightness, ${sdrBrightness}, sdrsaturation, ${sdrSaturation}, vrr, ${fourKvrrMode}"
        "DP-5,2560x1440@166,2560x0,${qhdScaling}"

        "DP-1,2560x1440@166,5120x1440,${qhdScaling}, cm, ${colorManagement}, sdrbrightness, ${sdrBrightness}, sdrsaturation, ${sdrSaturation}, vrr, ${vrrMode}"
        "DP-4,1920x1080@60,5120x0,${fhdScaling}"
      ];

    input.numlock_by_default = true;

    general = {
      gaps_in = 2;
      gaps_out = 2;
      border_size = 1;
      animation = [
        "windows, 0"
      ];
    };

    decoration = {
      rounding = 0;
      blur = {
        size = 6;
        passes = 3;
      };
    };

    misc = {
    };

    render = {
      cm_fs_passthrough = true;
    };

  };
}
