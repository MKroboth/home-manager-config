{ config, ... }:
{
  home.file = {
    ".config/wofi" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/elektra/wofi/";
    };
  };
}
