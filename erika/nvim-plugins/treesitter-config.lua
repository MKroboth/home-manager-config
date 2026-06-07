-- nvim-treesitter v1.x: the `nvim-treesitter.configs` module was removed.
-- Parsers are installed declaratively via nix (withPlugins), so we just
-- attach highlighting and indent on FileType.
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
    if vim.treesitter.language.get_lang(vim.bo[args.buf].filetype) then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
