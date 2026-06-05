{ config, lib, pkgs, ... }:

# Qt theming = Kvantum engine + the Colorful-Dark-Kvantum theme + a kdeglobals
# whose [Colors:*] sections mirror the Kvantum [GeneralColors] palette.
#
# The non-obvious bit: KDE apps split colour reads into two paths,
#   - QPalette          (set by Kvantum)
#   - KColorScheme      (read directly from kdeglobals)
# but more importantly, Kirigami/KCM/KFileItemDelegate widgets ALSO check the
# system colour-scheme (Light vs Dark) via Qt's QStyleHints. When that returns
# Unknown (the default on a non-Plasma Wayland session like Hyprland), those
# widgets render dark-text-for-light-background regardless of the palette —
# producing unreadable dark grey text on a translucent dark Kvantum surface.
#
# Fix: pretend Plasma is the running session via XDG_CURRENT_DESKTOP=KDE:Hyprland
# + KDE_FULL_SESSION=true + KDE_SESSION_VERSION=6. KDE apps then take the
# Plasma code path, KColorScheme initialises properly, and Kirigami picks the
# Dark variant. Hyprland-aware tools still see Hyprland in the colon-separated
# desktop list, so nothing else breaks.
let
  colorfulSrc = pkgs.fetchFromGitHub {
    owner = "L4ki";
    repo = "Colorful-Plasma-Themes";
    rev = "67fe0058dc44c3b86898fee1c930d718fcc834dc";
    sha256 = "0gbc172npy561x641bzn0az0yh5gya2in9kis9widqyig402wbkc";
  };

  themeName = "Colorful-Dark-Kvantum";
  themeDir = "${colorfulSrc}/Colorful Kvantum Themes/${themeName}";

  # kdeglobals — every [Colors:*] section uses the RGB triples that match the
  # Kvantum theme's [GeneralColors] block so QPalette and KColorScheme agree.
  #   window/button/alt.base #1c202f → 28,32,47
  #   base                   #242a3d → 36,42,61
  #   mid.light              #171b27 → 23,27,39
  #   text/window.text/button.text #d3dae3 → 211,218,227
  #   disabled.text          #586379 → 88,99,121
  #   tooltip.text           #edeff3 → 237,239,243
  #   highlight              #3667a6 → 54,103,166
  #   inactive.highlight     #2e4e7a → 46,78,122
  #   highlight.text         #ffffff → 255,255,255
  kdeglobalsConf = ''
    [General]
    ColorScheme=ColorfulDark
    Name=ColorfulDark
    shadeSortColumn=true

    [KDE]
    contrast=4
    widgetStyle=kvantum
    ColorScheme=ColorfulDark

    [Icons]
    Theme=Papirus-Dark

    [ColorEffects:Disabled]
    Color=88,99,121
    ColorAmount=0
    ColorEffect=0
    ContrastAmount=0.65
    ContrastEffect=1
    IntensityAmount=0.1
    IntensityEffect=2

    [ColorEffects:Inactive]
    ChangeSelectionColor=false
    Color=112,111,110
    ColorAmount=0
    ColorEffect=0
    ContrastAmount=0
    ContrastEffect=0
    Enable=false
    IntensityAmount=0
    IntensityEffect=0

    [Colors:Button]
    BackgroundAlternate=23,27,39
    BackgroundNormal=28,32,47
    DecorationFocus=54,103,166
    DecorationHover=54,103,166
    ForegroundActive=54,103,166
    ForegroundInactive=190,202,217
    ForegroundLink=54,103,166
    ForegroundNegative=218,68,83
    ForegroundNeutral=246,116,0
    ForegroundNormal=211,218,227
    ForegroundPositive=39,174,96
    ForegroundVisited=88,99,121

    [Colors:Complementary]
    BackgroundAlternate=46,52,71
    BackgroundNormal=36,42,61
    DecorationFocus=54,103,166
    DecorationHover=54,103,166
    ForegroundActive=54,103,166
    ForegroundInactive=190,202,217
    ForegroundLink=54,103,166
    ForegroundNegative=218,68,83
    ForegroundNeutral=246,116,0
    ForegroundNormal=211,218,227
    ForegroundPositive=39,174,96
    ForegroundVisited=88,99,121

    [Colors:Header]
    BackgroundAlternate=23,27,39
    BackgroundNormal=28,32,47
    DecorationFocus=54,103,166
    DecorationHover=54,103,166
    ForegroundActive=54,103,166
    ForegroundInactive=190,202,217
    ForegroundLink=54,103,166
    ForegroundNegative=218,68,83
    ForegroundNeutral=246,116,0
    ForegroundNormal=211,218,227
    ForegroundPositive=39,174,96
    ForegroundVisited=88,99,121

    [Colors:Selection]
    BackgroundAlternate=46,78,122
    BackgroundNormal=54,103,166
    DecorationFocus=255,255,255
    DecorationHover=255,255,255
    ForegroundActive=255,255,255
    ForegroundInactive=200,210,235
    ForegroundLink=253,188,75
    ForegroundNegative=218,68,83
    ForegroundNeutral=246,116,0
    ForegroundNormal=255,255,255
    ForegroundPositive=39,174,96
    ForegroundVisited=200,210,235

    [Colors:Tooltip]
    BackgroundAlternate=23,27,39
    BackgroundNormal=28,32,47
    DecorationFocus=54,103,166
    DecorationHover=54,103,166
    ForegroundActive=54,103,166
    ForegroundInactive=190,202,217
    ForegroundLink=54,103,166
    ForegroundNegative=218,68,83
    ForegroundNeutral=246,116,0
    ForegroundNormal=237,239,243
    ForegroundPositive=39,174,96
    ForegroundVisited=88,99,121

    [Colors:View]
    BackgroundAlternate=28,32,47
    BackgroundNormal=36,42,61
    DecorationFocus=54,103,166
    DecorationHover=54,103,166
    ForegroundActive=54,103,166
    ForegroundInactive=190,202,217
    ForegroundLink=54,103,166
    ForegroundNegative=218,68,83
    ForegroundNeutral=246,116,0
    ForegroundNormal=211,218,227
    ForegroundPositive=39,174,96
    ForegroundVisited=88,99,121

    [Colors:Window]
    BackgroundAlternate=23,27,39
    BackgroundNormal=28,32,47
    DecorationFocus=54,103,166
    DecorationHover=54,103,166
    ForegroundActive=54,103,166
    ForegroundInactive=190,202,217
    ForegroundLink=54,103,166
    ForegroundNegative=218,68,83
    ForegroundNeutral=246,116,0
    ForegroundNormal=211,218,227
    ForegroundPositive=39,174,96
    ForegroundVisited=88,99,121

    [WM]
    activeBackground=28,32,47
    activeBlend=171,171,171
    activeForeground=211,218,227
    inactiveBackground=23,27,39
    inactiveBlend=85,85,85
    inactiveForeground=88,99,121
  '';
in
{
  home.packages = with pkgs; [
    qt6Packages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum
  ];

  # Shells see these via hm-session-vars.sh; Hyprland-spawned Qt apps also
  # get them via hl.env(...) in hyprland.lua.
  home.sessionVariables = {
    QT_STYLE_OVERRIDE = "kvantum";
    # Make KDE apps believe Plasma is the active session. Without these,
    # Kirigami/KCM/KFileItemDelegate widgets default to a light colour scheme
    # because QStyleHints::colorScheme() returns Unknown on Hyprland.
    XDG_CURRENT_DESKTOP = lib.mkForce "KDE:Hyprland";
    KDE_SESSION_VERSION = "6";
    KDE_FULL_SESSION = "true";
  };

  # Kvantum theme files + the engine's "active theme" pointer.
  #
  # The upstream .kvconfig is patched at build time:
  #   respect_DE=true → respect_DE=false: force Kvantum to use its own
  #     [GeneralColors] palette directly instead of yielding to KColorScheme.
  #   no_inactiveness=false → true: stop Kvantum from dimming widgets when the
  #     window is unfocused (otherwise inactive text falls back to
  #     disabled.text.color = #586379 = the unreadable grey we hunted).
  xdg.configFile."Kvantum/${themeName}/${themeName}.kvconfig".text =
    builtins.replaceStrings
      [ "respect_DE=true" "no_inactiveness=false" ]
      [ "respect_DE=false" "no_inactiveness=true" ]
      (builtins.readFile "${themeDir}/${themeName}.kvconfig");
  xdg.configFile."Kvantum/${themeName}/${themeName}.svg".source =
    "${themeDir}/${themeName}.svg";
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=${themeName}
  '';

  # KColorScheme reads sections directly from kdeglobals at runtime.
  xdg.configFile."kdeglobals".text = kdeglobalsConf;

  # And from a matching scheme file when [General] ColorScheme= resolves a name.
  xdg.dataFile."color-schemes/ColorfulDark.colors".text = kdeglobalsConf;

  # ~/.config/kdedefaults/ is the "applied Plasma look-and-feel" cache from
  # earlier Plasma installs. Its kdeglobals overlay pins ColorScheme=BreezeDark
  # + widgetStyle=Breeze and KConfig MERGES it INTO our kdeglobals — so any
  # KDE app reading kdeglobals would see Breeze override Colorful. On Hyprland
  # this dir is dead weight; purge it on every activation.
  home.activation.purgeKdedefaults = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -d "$HOME/.config/kdedefaults" ] && [ ! -L "$HOME/.config/kdedefaults" ]; then
      run rm -rf "$HOME/.config/kdedefaults"
    fi
  '';
}
