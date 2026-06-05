{ config, pkgs, ... }:

{
  programs.zsh = {
    envExtra = # bash
      ''
        # Make Nix-profile GIR typelibs discoverable (ags, astal-*)
        export GI_TYPELIB_PATH="$HOME/.nix-profile/lib/girepository-1.0''${GI_TYPELIB_PATH:+:$GI_TYPELIB_PATH}"

        # Expose per-package GSettings schemas from the Nix profile via XDG_DATA_DIRS
        for _d in "$HOME"/.nix-profile/share/gsettings-schemas/*/; do
          [ -d "$_d" ] || continue
          case ":''${XDG_DATA_DIRS:-}:" in
            *":''${_d%/}:"*) ;;
            *) XDG_DATA_DIRS="''${_d%/}''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}" ;;
          esac
        done
        unset _d
        export XDG_DATA_DIRS
      '';
    initContent = # bash
      ''
        [[ ! -f "${./p10k.zsh}" ]] || source ${./p10k.zsh}
        [[ ! -f "~/.cargo/env" ]] || source ~/.cargo/env
        source <(fzf --zsh)
      '';
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch --flake /home/mkr/Documents/src/nixos/";
      raudio = "pactl load-module module-tunnel-sink server=tcp:192.168.0.1:4656";
      hm = "home-manager";
      nxsh = "nix-shell --run zsh";
      page = "zathura -";
    };
    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";
  };
}
