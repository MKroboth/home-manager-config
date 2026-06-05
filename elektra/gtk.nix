{
  config,
  pkgs,
  ...
}:

let
  glassCss = ''
    /* Liquid-glass surface treatment for GTK apps.
       Window-level translucency is handled by Hyprland window rules. */

    headerbar,
    .titlebar {
      background-color: rgba(12, 12, 18, 0.72);
      box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.08),
                  0 1px 0 rgba(0, 0, 0, 0.35);
      border-bottom: 1px solid rgba(255, 255, 255, 0.12);
      color: rgba(255, 255, 255, 0.92);
    }

    popover,
    popover.background,
    popover > arrow,
    popover > contents {
      background-color: rgba(12, 12, 18, 0.78);
      border: 1px solid rgba(255, 255, 255, 0.12);
      border-radius: 14px;
      box-shadow: 0 12px 32px rgba(0, 0, 0, 0.45);
      color: rgba(255, 255, 255, 0.92);
    }

    menu,
    .menu,
    menuitem,
    .context-menu {
      background-color: rgba(12, 12, 18, 0.78);
      border: 1px solid rgba(255, 255, 255, 0.12);
      border-radius: 12px;
      color: rgba(255, 255, 255, 0.92);
    }

    menuitem:hover,
    .menu menuitem:hover {
      background-color: rgba(122, 175, 255, 0.18);
      border-radius: 8px;
    }

    tooltip,
    tooltip.background {
      background-color: rgba(12, 12, 18, 0.85);
      border: 1px solid rgba(255, 255, 255, 0.12);
      border-radius: 10px;
      color: rgba(255, 255, 255, 0.92);
      text-shadow: none;
    }

    button {
      border-radius: 10px;
    }

    button.suggested-action,
    button.default {
      background-color: rgba(122, 175, 255, 0.22);
      border-color: rgba(122, 175, 255, 0.35);
      color: rgba(255, 255, 255, 0.96);
    }

    entry,
    .entry {
      border-radius: 10px;
      background-color: rgba(255, 255, 255, 0.06);
      border: 1px solid rgba(255, 255, 255, 0.12);
    }

    entry:focus,
    .entry:focus {
      border-color: rgba(122, 175, 255, 0.55);
      box-shadow: 0 0 0 2px rgba(122, 175, 255, 0.18);
    }

    scrollbar slider {
      background-color: rgba(255, 255, 255, 0.18);
      border-radius: 8px;
      min-width: 8px;
      min-height: 8px;
    }

    scrollbar slider:hover {
      background-color: rgba(255, 255, 255, 0.28);
    }
  '';
in
{
  gtk = {
    enable = true;

    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name = "Arc";
      package = pkgs.arc-icon-theme;
    };

    gtk3 = {
      bookmarks = [ "file:///tmp" ];
      extraConfig.gtk-application-prefer-dark-theme = true;
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

  # Libadwaita reads colour scheme from this dconf key.
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-theme = "adw-gtk3-dark";
  };
}
