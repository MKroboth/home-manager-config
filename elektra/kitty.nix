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
      cursor_shape = "beam";

      window_padding_width = 10;
      hide_window_decorations = "yes";
    };
    # Colour scheme lives in ~/.cache/kitty/current-theme.conf so apply-theme
    # can swap it at runtime and signal kitty with SIGUSR1 to live-reload —
    # kitty silently ignores the include if the file is missing.
    extraConfig = ''
      include ~/.cache/kitty/current-theme.conf
    '';
  };

  home.file = {
    ".config/kitty/themes/dark.conf".text = ''
      background           #0a0a12
      foreground           #eaeaf0
      selection_background #7aafff
      selection_foreground #0a0a12
      cursor               #b8a4ff

      # 16-colour ANSI palette — normals are slightly muted, brights map
      # to the same pastel accents used by hyprland borders.
      color0  #1a1a26
      color8  #383848
      color1  #d97070
      color9  #ffa0c4
      color2  #5dbf82
      color10 #7adca0
      color3  #d6bd5f
      color11 #f0d875
      color4  #6296e0
      color12 #7aafff
      color5  #9d8fdc
      color13 #b8a4ff
      color6  #5dc4c4
      color14 #7ae0e0
      color7  #bfbfcc
      color15 #eaeaf0
    '';

    ".config/kitty/themes/light.conf".text = ''
      background           #fafafb
      foreground           #1a1a22
      selection_background #3a6dd1
      selection_foreground #ffffff
      cursor               #6750a4

      # 16-colour ANSI palette — darker, more saturated so TUIs read on
      # the off-white background. color0/color15 inverted from dark so
      # apps using color0-on-color15 stay legible.
      color0  #2a2a35
      color8  #5a5a68
      color1  #c4344b
      color9  #d04060
      color2  #2c8a4a
      color10 #38a05c
      color3  #a07418
      color11 #c69020
      color4  #2256b8
      color12 #3a6dd1
      color5  #6e3fb8
      color13 #8458d4
      color6  #1f8a8a
      color14 #2da6a6
      color7  #d0d0dc
      color15 #1a1a22
    '';
  };

  # Seed the runtime-owned theme file on first build so a freshly-opened
  # kitty window starts in the persisted mode (or dark by default).
  home.activation.seedKittyTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.cache/kitty"
    if [ ! -e "$HOME/.cache/kitty/current-theme.conf" ]; then
      mode=$(cat "$HOME/.cache/eww-theme" 2>/dev/null || echo dark)
      run cp -f "$HOME/.config/kitty/themes/$mode.conf" \
        "$HOME/.cache/kitty/current-theme.conf" 2>/dev/null || true
    fi
  '';
}
