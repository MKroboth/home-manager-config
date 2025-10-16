{ config, ... }:
{
  home.file = {
    ".config/eww" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/elektra/eww/";
    };
  };
}
