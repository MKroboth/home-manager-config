{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = let vp = pkgs.vimPlugins; in [
      # WARN the order of the plugins is important 
       vp.vim-sleuth
      
      {
        plugin = vp.hardtime-nvim;
        config = builtins.readFile ./nvim-plugins/hardtime.lua;
        type = "lua";
      }
      { 
        plugin = vp.comment-nvim;
        config = "require('Comment').setup()";
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
        config = "require('fidget').setup()";
        type = "lua";
      }
      { 
        plugin = vp.neodev-nvim;
        config = "require('neodev').setup()";
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
        plugin = vp.nvim-treesitter.withPlugins(_: pkgs.tree-sitter.allGrammars);
        config = builtins.readFile ./nvim-plugins/treesitter-config.lua;
        type = "lua";
      }
    ];
    extraLuaConfig = builtins.readFile ./vim-extra-config.lua;
    };
}
