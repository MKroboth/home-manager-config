{ pkgs, ... }:

{
  # Install an actually working neovim wrapper
  xdg.desktopEntries."neovim-giga-wrapper" = {
    name = "NeoVim Kitty Wrapper";
    exec = "kitty nvim -- %u";
    terminal = false;
    type = "Application";
    categories = [
      "Utility"
      "TextEditor"
    ];
    mimeType = [
      "text/english"
      "text/plain"
      "text/x-makefile"
      "text/x-c++hdr"
      "text/x-c++src"
      "text/x-chdr"
      "text/x-csrc"
      "text/x-java"
      "text/x-moc"
      "text/x-pascal"
      "text/x-tcl"
      "text/x-tex"
      "application/x-shellscript"
      "text/x-c"
      "text/x-c++"
    ];
  };
  # Language Servers
  home.packages = with pkgs; [
    # vscode-langservers-extracted
    cmake-language-server
    sumneko-lua-language-server
    gopls
    pyright
    yaml-language-server
    elixir-ls
  ];
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins =
      let
        vp = pkgs.vimPlugins;
      in
      [
        # WARN the order of the plugins is important
        vp.vim-sleuth

        {
          plugin = vp.hardtime-nvim;
          config = builtins.readFile ./nvim-plugins/hardtime.lua;
          type = "lua";
        }
        {
          plugin = vp.comment-nvim;
          config = # lua
            "require('Comment').setup()";
          type = "lua";
        }

        {
          plugin = vp.gitsigns-nvim;
          config = builtins.readFile ./nvim-plugins/gitsigns-opts.lua;
          type = "lua";
        }
        {
          plugin = vp.which-key-nvim;
          config = builtins.readFile ./nvim-plugins/which-key-config.lua;
          type = "lua";
        }
        vp.telescope-ui-select-nvim
        vp.telescope-fzf-native-nvim
        vp.vim-devicons
        {
          plugin = vp.telescope-nvim;
          config = builtins.readFile ./nvim-plugins/telescope-config.lua;
          type = "lua";
        }
        {
          plugin = vp.fidget-nvim;
          config = # lua
            "require('fidget').setup()";
          type = "lua";
        }
        {
          plugin = vp.neodev-nvim;
          config = # lua
            "require('neodev').setup()";
          type = "lua";
        }
        {
          plugin = vp.nvim-lspconfig;
          config = builtins.readFile ./nvim-plugins/nvim-lspconfig-config.lua;
          type = "lua";
        }
        {
          plugin = vp.conform-nvim;
          config = builtins.readFile ./nvim-plugins/conform-config.lua;
          type = "lua";
        }
        vp.luasnip
        vp.cmp-nvim-lsp
        vp.cmp-async-path
        {
          plugin = vp.nvim-cmp;
          config = builtins.readFile ./nvim-plugins/cmp-config.lua;
          type = "lua";
        }
        {
          plugin = vp.catppuccin-nvim;
          config = builtins.readFile ./nvim-plugins/theme.lua;
          type = "lua";
        }
        {
          plugin = vp.todo-comments-nvim;
          config = builtins.readFile ./nvim-plugins/todo-comments-opts.lua;
          type = "lua";
        }
        {
          plugin = vp.mini-nvim;
          config = builtins.readFile ./nvim-plugins/mini-config.lua;
          type = "lua";
        }
        {
          plugin = vp.nvim-treesitter.withPlugins (plugin: ([
            plugin.lua
            plugin.luadoc
            plugin.typescript
            plugin.toml
            plugin.ssh_config
            plugin.sql
            plugin.scss
            plugin.rust
            plugin.ron
            plugin.printf
            plugin.php
            plugin.phpdoc
            plugin.nix
            plugin.nasm
            plugin.markdown
            plugin.llvm
            plugin.latex
            plugin.json
            plugin.jsdoc
            plugin.javascript
            plugin.ini
            plugin.hyprlang
            plugin.html
            plugin.haskell
            plugin.gpg
            plugin.glsl
            plugin.gitignore
            plugin.gitcommit
            plugin.gitattributes
            plugin.git_rebase
            plugin.git_config
            plugin.dockerfile
            plugin.diff
            plugin.dart
            plugin.csv
            plugin.css
            plugin.cpp
            plugin.cmake
            plugin.c
            plugin.awk
            plugin.ada
            plugin.bash
            plugin.yuck
            plugin.elixir
          ]));
          config = builtins.readFile ./nvim-plugins/treesitter-config.lua;
          type = "lua";
        }
        pkgs.vimPlugins.vim-fugitive
      ];
    extraLuaPackages = ps: [
      ps.image-nvim
      ps.magick
    ];
    extraPackages = [
      pkgs.imagemagick
      pkgs.luajitPackages.magick
    ];
    extraLuaConfig = builtins.readFile ./vim-extra-config.lua;
  };
}
