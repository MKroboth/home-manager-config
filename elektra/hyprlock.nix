{ ... }:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        grace = 0;
        no_fade_in = false;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
          contrast = 0.9;
          brightness = 0.8;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "320, 56";
          position = "0, -100";
          halign = "center";
          valign = "center";
          dots_center = true;
          dots_spacing = 0.3;
          fade_on_empty = false;
          font_color = "rgb(eaeaf0)";
          inner_color = "rgba(12, 12, 18, 0.8)";
          outer_color = "rgba(122, 175, 255, 0.4)";
          outline_thickness = 2;
          placeholder_text = ''<i>Password…</i>'';
          shadow_passes = 2;
          rounding = 12;
        }
      ];

      label = [
        {
          monitor = "";
          text = ''cmd[update:1000] date +"%H:%M"'';
          font_size = 96;
          font_family = "FiraCode Nerd Font Propo";
          color = "rgb(eaeaf0)";
          position = "0, 220";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = ''cmd[update:60000] date +"%A, %B %d"'';
          font_size = 22;
          font_family = "FiraCode Nerd Font Propo";
          color = "rgba(234, 234, 240, 0.75)";
          position = "0, 130";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
