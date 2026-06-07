{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # KDE portal: themed file picker, Settings (color-scheme), Inhibit, etc.
    # FileChooser inherits kvantum so it matches the rest of the rice.
    kdePackages.xdg-desktop-portal-kde
    # GTK portal: safety-net for any interface KDE doesn't implement.
    xdg-desktop-portal-gtk
  ];

  # XDG_CURRENT_DESKTOP is "KDE:Hyprland", so xdg-desktop-portal searches
  # for kde-portals.conf first, then hyprland-portals.conf, then portals.conf
  # — and within each name, $XDG_CONFIG_HOME wins over system dirs. Writing
  # kde-portals.conf here is the highest-priority override.
  xdg.configFile."xdg-desktop-portal/kde-portals.conf".text = ''
    [preferred]
    default=kde;gtk
    org.freedesktop.impl.portal.Screenshot=hyprland
    org.freedesktop.impl.portal.ScreenCast=hyprland
    org.freedesktop.impl.portal.GlobalShortcuts=hyprland
  '';
}
