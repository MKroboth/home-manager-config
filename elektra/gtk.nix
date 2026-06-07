{
  pkgs,
  ...
}:

let
  glassCss = ''
    /* Liquid-glass surface treatment for GTK apps.
       Colours come from the active adw-gtk3 variant via named colours
       (@theme_bg_color, @theme_fg_color, @accent_color), so the glass
       automatically follows whichever colour-scheme is loaded.
       Window-level translucency is handled by Hyprland window rules. */

    headerbar,
    .titlebar {
      background-color: alpha(@theme_bg_color, 0.72);
      box-shadow: inset 0 1px 0 alpha(@theme_fg_color, 0.08),
                  0 1px 0 alpha(black, 0.35);
      border-bottom: 1px solid alpha(@theme_fg_color, 0.12);
      color: @theme_fg_color;
    }

    popover,
    popover.background,
    popover > arrow,
    popover > contents {
      background-color: alpha(@theme_bg_color, 0.78);
      border: 1px solid alpha(@theme_fg_color, 0.12);
      border-radius: 14px;
      box-shadow: 0 12px 32px alpha(black, 0.45);
      color: @theme_fg_color;
    }

    menu,
    .menu,
    menuitem,
    .context-menu {
      background-color: alpha(@theme_bg_color, 0.78);
      border: 1px solid alpha(@theme_fg_color, 0.12);
      border-radius: 12px;
      color: @theme_fg_color;
    }

    menuitem:hover,
    .menu menuitem:hover {
      background-color: alpha(@accent_color, 0.22);
      border-radius: 8px;
    }

    tooltip,
    tooltip.background {
      background-color: alpha(@theme_bg_color, 0.85);
      border: 1px solid alpha(@theme_fg_color, 0.12);
      border-radius: 10px;
      color: @theme_fg_color;
      text-shadow: none;
    }

    button {
      border-radius: 10px;
    }

    button.suggested-action,
    button.default {
      background-color: alpha(@accent_color, 0.25);
      border-color: alpha(@accent_color, 0.40);
      color: @theme_fg_color;
    }

    entry,
    .entry {
      border-radius: 10px;
      background-color: alpha(@theme_fg_color, 0.06);
      border: 1px solid alpha(@theme_fg_color, 0.12);
    }

    entry:focus,
    .entry:focus {
      border-color: alpha(@accent_color, 0.60);
      box-shadow: 0 0 0 2px alpha(@accent_color, 0.20);
    }

    scrollbar slider {
      background-color: alpha(@theme_fg_color, 0.18);
      border-radius: 8px;
      min-width: 8px;
      min-height: 8px;
    }

    scrollbar slider:hover {
      background-color: alpha(@theme_fg_color, 0.28);
    }
  '';
in
{
  # Theme + icon packages installed directly instead of via gtk.{theme,iconTheme}
  # because that home-manager module re-runs `gsettings set gtk-theme` on every
  # rebuild, fighting the runtime toggle. The active theme/icon-theme is owned by
  # ~/.cache/eww-theme + ~/.config/ags/scripts/apply-theme.
  home.packages = with pkgs; [
    adw-gtk3
    papirus-icon-theme
  ];

  gtk = {
    enable = true;

    gtk3 = {
      bookmarks = [ "file:///tmp" ];
      extraCss = glassCss;
    };

    gtk4 = {
      extraCss = glassCss;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = "catppuccin-frappe-blue-cursors";
    package = pkgs.catppuccin-cursors.frappeBlue;
  };
}
