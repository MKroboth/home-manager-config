{ config, ... }:
{
  home.file = {
    ".config/eww/eww.yuck" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/elektra/eww.yuck";
    };
    ".config/eww/eww.scss" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/elektra/eww.scss";
    };
    ".config/eww/scripts" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/elektra/eww-scripts";
    };
  };
}
