{
  config,
  ...
}:
{
  home.file = {
    ".config/hypr/hyprland.lua" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/hyprland.lua";
    };
  };
}
