{ lib, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig =
      let
        mkBind = key: action: ''
          bind=${key},${action}
          bind=${key},submap,reset'';
        resetSubmap = ''
          bind=,Return,submap,reset
          bind=,Escape,submap,reset
          submap=reset
        '';
      in
      # setup keybindings for launching applications
      lib.concatStrings [
        ''
          submap=execute
          ${mkBind ",w" "exec,$browser"}
          ${mkBind ",e" "exec,$editor"}
          ${mkBind ",n" "exec,$notes"}
          ${mkBind ",f" "exec,$fileManager"}
        ''
        resetSubmap
      ];

    settings = {
      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$menu" = "wofi --show drun,run";
      "$dmenu" = "wofi --show dmenu";
      "$fileManager" = "thunar";
      "$notes" = "obsidian";
      "$chat" = "element-desktop";
      "$editor" = "emacs";
      "$browser" = "brave";

      windowrulev2 = [
        "opacity 0.93, class:.*" # make all windows 4% transparent
        "opacity 1,title:^(.*)(YouTube)(.*)$" # if a window has "YouTube" in its title, remove transparency
        "opacity 1,title:^FINAL FANTASY XIV$"
        "suppressevent maximize, class:.*"
        #        "forceinput, class:.*"
        "minsize 1 1 , title:^(),class:^(steam)"
        "stayfocused,class:(steam),title:(^$)"
        "opacity 1,fullscreen:1"
      ];

      binds = {
        workspace_center_on = 1;
      };

      input = {
        kb_layout = "us";
        kb_options = "caps:escape,compose:menu"; # override capslock with escape

        follow_mouse = 1;

        touchpad.natural_scroll = false;

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };

      general = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        gaps_in = 10;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        layout = "dwindle";

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;
      };

      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        rounding = 10;

        blur = {
          enabled = true;
          size = 3;
          passes = 1;

          vibrancy = 0.1696;
        };

        #drop_shadow = true;
        # shadow_range = 4;
        # shadow_render_power = 3;
        #   "col.shadow" = "rgba(1a1a1aee)";
      };

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = true;
        preserve_split = true; # you probably want this
      };

      gestures = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = true;
      };

      bind =
        [
          "$mod, X, submap, execute"
          "$mod+SHIFT, C, killactive"
          "$mod SHIFT, Return, exec, $terminal"
          "$mod SHIFT, C, killactive,"
          # "$mod SHIFT, Q, exit,"
          "$mod SHIFT, Space,togglefloating,"
          "$mod, P, exec, $menu"
          "$mod SHIFT, P, pseudo,"
          "$mod SHIFT, J, togglesplit,"
          "$mod SHIFT, F, fullscreen"
          "$mod, H, movefocus, l"
          "$mod, L, movefocus, r"
          "$mod, K, movefocus, u"
          "$mod, J, movefocus, d"
          "$mod,Y,exec,grimblast copy area"
          "$mod SHIFT,W,movecurrentworkspacetomonitor,2"
          "$mod SHIFT,E,movecurrentworkspacetomonitor,1"
          "$mod SHIFT,R,movecurrentworkspacetomonitor,0"
          "$mod ,W,focusmonitor,2"
          "$mod ,E,focusmonitor,1"
          "$mod ,R,focusmonitor,0"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (
            builtins.genList (
              x:
              let
                ws =
                  let
                    c = (x + 1) / 10;
                  in
                  builtins.toString (x + 1 - (c * 10));
              in
              [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
              ]
            ) 10
          )
        );
      bindm = [
        "bindm = $mod, mouse:272, movewindow"
        "bindm = $mod, mouse:273, resizewindow"
      ];
    };
  };
}
