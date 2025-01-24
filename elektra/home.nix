{ pkgs, ... }:

{
  imports = [
    ./doom.nix
    ./nvim.nix
    ./hyprland.nix
    ./waybar.nix
    ./zsh.nix
    ./packages.nix
    ./gtk.nix
    ./kitty.nix
    ./digital-audio-workstation.nix
    ./eww.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mkr";
  home.homeDirectory = "/home/mkr";
  wayland.windowManager.hyprland.enable = true;
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ "electron-25.9.0" ];
  };
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mkr/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    SSH_ASKPASS = "${pkgs.x11_ssh_askpass}/libexec/ssh-askpass";
  };

  programs.git = {
    enable = true;
    userName = "Maximilian Kroboth";
    userEmail = "maximilian@kroboth-home.at";
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs; # replace with pkgs.emacs-gtk, or a version provided by the community overlay if desired.
  };

  systemd.user.services.pulseaudio-pipewire-modules = {
    Unit = {
      Description = "Load pipewire-pulseaudio modules";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = "${pkgs.writeShellScript "load-pulseaudio-pipewire-modules" ''
        #!/run/current-system/sw/bin/bash
        ${pkgs.pulseaudio}/bin/pactl load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1
      ''}";
    };
  };
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
