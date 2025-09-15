{ pkgs, ... }:
{

  home.packages = with pkgs; [
    ardour
    helm
    alsa-scarlett-gui
    easyeffects
  ];
  home.sessionVariables = {
    LV2_PATH = "~/.local/state/nix/profiles/profile/lib/lv2";
  };
}
