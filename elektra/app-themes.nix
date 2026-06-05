{ config, ... }:
{
  # Vesktop reads themes from ~/.config/vesktop/themes/<name>.theme.css and
  # the directory is stable, so we can wire it automatically.
  # Librewolf and Obsidian themes need per-profile / per-vault linking and
  # ship as plain CSS in elektra/app-themes/ for manual `ln -s` (one-time).
  home.file.".config/vesktop/themes/liquid-glass.theme.css" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/elektra/app-themes/vesktop-liquid-glass.theme.css";
  };
}
