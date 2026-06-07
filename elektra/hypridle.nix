{ ... }:

{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        # `pidof` guard prevents stacking lockers when both hypridle and the
        # AGS button (via loginctl lock-session) fire close together.
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 900;        # 15 min idle → lock
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 1200;       # 20 min idle → blank all 6 displays
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
