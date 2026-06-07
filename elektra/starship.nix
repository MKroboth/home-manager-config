{ ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$character";
      right_format = "$status$cmd_duration$jobs$direnv$rust$username$hostname$nix_shell";

      directory = {
        style = "bold #00afff";
        truncate_to_repo = true;
        truncation_length = 3;
        truncation_symbol = "…/";
        read_only = " 󰌾";
      };

      git_branch = {
        symbol = " ";
        style = "bold green";
        format = "[$symbol$branch(:$remote_branch)]($style) ";
        truncation_length = 32;
        truncation_symbol = "…";
      };

      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "green";
        conflicted = "~$count";
        ahead = " ⇡$count";
        behind = " ⇣$count";
        diverged = " ⇡$ahead_count⇣$behind_count";
        up_to_date = "";
        untracked = " ?$count";
        stashed = " *$count";
        modified = " !$count";
        staged = " +$count";
        renamed = " »$count";
        deleted = "";
      };

      # $symbol embeds its own color so style is left empty
      status = {
        disabled = false;
        format = "$symbol ";
        symbol = "[✘](bold red)";
        success_symbol = "[✔](bold green)";
        style = "";
        map_symbol = true;
      };

      cmd_duration = {
        min_time = 3000;
        format = "[$duration]($style) ";
        style = "fg:#aaaaaa";
        show_milliseconds = false;
      };

      jobs = {
        symbol = "⚙";
        style = "bold cyan";
        format = "[$symbol]($style) ";
        number_threshold = 1;
        symbol_threshold = 1;
      };

      direnv = {
        disabled = false;
        format = "[$symbol$loaded/$allowed]($style) ";
        symbol = "direnv ";
        style = "bold yellow";
        allowed_msg = "";
        not_allowed_msg = "!";
        denied_msg = "!!";
        loaded_msg = "";
        unloaded_msg = "";
      };

      rust = {
        symbol = " ";
        style = "bold #f74c00";
        format = "[$symbol$version]($style) ";
        detect_files = [ "Cargo.toml" ];
      };

      # Only shown in SSH / root — mirrors p10k context behaviour
      username = {
        show_always = false;
        format = "[$user]($style)";
        style_user = "bold yellow";
        style_root = "bold red";
      };

      hostname = {
        ssh_only = true;
        format = "@[$hostname]($style) ";
        style = "bold yellow";
      };

      nix_shell = {
        disabled = false;
        impure_msg = "impure";
        pure_msg = "pure";
        unknown_msg = "?";
        format = "[ $state( \\($name\\))]($style) ";
        style = "bold #74c7ec";
      };

      # Changes ❯ → ❮ in normal mode, mirrors p10k prompt_char colours
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold green)";
        vimcmd_replace_one_symbol = "[❮](bold yellow)";
        vimcmd_replace_symbol = "[❮](bold yellow)";
        vimcmd_visual_symbol = "[❮](bold blue)";
      };
    };
  };
}
