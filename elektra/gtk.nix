{
  config,
  pkgs,
  ...
}:

{
  #  catppuccin.gtk.enable = true;
  # catppuccin = {
  #   enable = true;
  #   flavor = "frappe";
  #   accent = "blue";
  # };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Arc";
      package = pkgs.arc-icon-theme;
    };

    gtk3 = {
      bookmarks = [ "file:///tmp" ];
      extraConfig.gtk-application-prefer-dark-theme = true;
    };
  };
  #
  home.pointerCursor = {
    gtk.enable = true;
    name = "catppuccin-frappe-blue-cursors";
    package = pkgs.catppuccin-cursors.frappeBlue;
  };

  # xdg.configFile = {
  #   "gtk-4.0/assets".source =
  #     "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
  #   "gtk-4.0/gtk.css".source =
  #     "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
  #   "gtk-4.0/gtk-dark.css".source =
  #     "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  # };
  # dconf.settings."org/gnome/desktop/interface" = {
  #   gtk-theme = lib.mkForce "Catppuccin-Frappe";
  #   color-scheme = "prefer-dark";
  # };
}
