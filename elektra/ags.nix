{ config, ... }:
{
  home.file = {
    ".config/ags" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/elektra/ags/";
    };
  };
}
