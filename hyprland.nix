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

      windowrulev2 =
        let
          intellijFixes = [
            #! Fix focus issues when dialogs are opened or closed
            #  "windowdance,class:^(jetbrains-.*)$,floating:1"
            #! Fix splash screen showing in weird places and prevent annoying focus takeovers
            "center,class:^(jetbrains-.*)$,title:^(splash)$,floating:1"
            "nofocus,class:^(jetbrains-.*)$,title:^(splash)$,floating:1"
            "noborder,class:^(jetbrains-.*)$,title:^(splash)$,floating:1"

            #! Center popups/find windows
            "center,class:^(jetbrains-.*)$,title:^( )$,floating:1"
            "stayfocused,class:^(jetbrains-.*)$,title:^( )$,floating:1"
            "noborder,class:^(jetbrains-.*)$,title:^( )$,floating:1"
            #! Disable window flicker when autocomplete or tooltips appear
            "nofocus,class:^(jetbrains-.*)$,title:^(win.*)$,floating:1"

          ];
          nonTransparentWindows = [
            "title:^(.*)(YouTube)(.*)$"
            "title:^FINAL FANTASY XIV$"
          ];
          fixSteam = [
            "minsize 1 1 , title:^(),class:^(steam)"
            "stayfocused,class:(steam),title:(^$)"
            "content game, class:^(steam_app_)(.*)$"
          ];
          defaultTransparency = 0.04;
        in
        intellijFixes
        ++ (map (window: "opacity 1,${window}") nonTransparentWindows)
        ++ fixSteam
        ++ [
          "opacity ${toString (1.0 - defaultTransparency)}, class:.*" # make all windows 4% transparent
          "suppressevent maximize, class:.*"
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

      general = lib.mkDefault {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        gaps_in = lib.mkDefault 10;
        gaps_out = lib.mkDefault 20;
        border_size = lib.mkDefault 2;
        "col.active_border" = lib.mkDefault "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = lib.mkDefault "rgba(595959aa)";

        layout = lib.mkDefault "dwindle";

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = lib.mkDefault false;
      };

      decoration = lib.mkDefault {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        rounding = lib.mkDefault 10;

        blur = lib.mkDefault {
          enabled = lib.mkDefault true;
          size = lib.mkDefault 3;
          passes = lib.mkDefault 1;

          vibrancy = lib.mkDefault 0.1696;
        };

        #drop_shadow = true;
        # shadow_range = 4;
        # shadow_render_power = 3;
        #   "col.shadow" = "rgba(1a1a1aee)";
      };

      dwindle = lib.mkDefault {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = lib.mkDefault true;
        preserve_split = lib.mkDefault true; # you probably want this
      };

      gestures = lib.mkDefault {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = lib.mkDefault true;
      };

      bind =
        [
          "SHIFT, F2, pass, class:^(FF Logs Uploader)$"
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
