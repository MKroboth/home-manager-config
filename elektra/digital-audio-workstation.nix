{ pkgs, ... }:
{

  home.packages = with pkgs; [
    ardour
    helm
    alsa-scarlett-gui
    easyeffects
    mda_lv2
    swh_lv2
    airwindows-lv2
    rkrlv2
  ];
  home.sessionVariables = {
    LV2_PATH = "~/.local/state/nix/profiles/profile/lib/lv2";
  };
}
