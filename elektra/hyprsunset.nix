{ ... }:

{
  # Runs the hyprsunset daemon so `hyprctl hyprsunset temperature/gamma ...`
  # IPC calls from the AGS control center
  # actually have something to talk to. No schedule — temperature is driven
  # interactively by those widgets.
  services.hyprsunset = {
    enable = true;
    settings = {
      max-gamma = 100;
    };
  };
}
