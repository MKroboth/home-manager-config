{ pkgs, ... }:
{

  home.packages = with pkgs; [
    ardour
    sunvox
    x42-plugins
    infamousPlugins
    drumgizmo
    guitarix
    gxplugins-lv2
    airwindows-lv2
    distrho
    helm
    soundfont-arachno
    aeolus
    aeolus-stops
    alsa-scarlett-gui
  ];
  home.sessionVariables = {
    LV2_PATH = ~/.local/state/nix/profiles/profile/lib/lv2;
  };
}
