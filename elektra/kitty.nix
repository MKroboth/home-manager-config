{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    #    theme = "Catppuccin-Frappe";
    font = {
      name = "FiraCode";
    };
    shellIntegration = {
      enableZshIntegration = true;
    };
  };
}
