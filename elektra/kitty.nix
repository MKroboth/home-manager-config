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
    font = {
      name = "FiraCode";
    };
    shellIntegration = {
      enableZshIntegration = true;
    };
    enableGitIntegration = true;
    settings = {
      confirm_os_window_close = 0;
      background_opacity = 0.6;
    };
  };
}
