{ config, ... }:
{
  home.file = {
    ".config/eww/eww.yuck" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/eww.yuck";
    };
    ".config/eww/eww.scss" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/eww.scss";
    };
  };
}
