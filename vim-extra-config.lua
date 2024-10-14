-- NeoVIM Configuration

do --#region Globals
  -- Set <space> as the leader key
  -- See `:help mapleader`

  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  -- set to true if you truely want to learn neovim.
  vim.g.hardmode = true

  -- set to true if you want to force yourself to use advanced movements.
  vim.g.i_hate_myself = false

  -- Set to true if you have a Nerd Font installed and selected in the terminal
  vim.g.have_nerd_font = true
  --
end --#endregion

do  --#region Setting Options
  -- See `:help vim.opt`
  -- NOTE: You can change these options as you wish!
  --  For more options, you can see `:help option-list`

  -- Make line numbers default
  vim.opt.number = true
  -- You can also add relative line numbers, to help with jumping.
  --  Experiment for yourself to see if you like it!
  vim.opt.relativenumber = true

  -- Enable mouse mode, can be useful for resizing splits for example!
  vim.opt.mouse = 'a'

  -- Don't show the mode, since it's already in the status line
  vim.opt.showmode = false

  -- Sync clipboard between OS and Neovim.
  --  Remove this option if you want your OS clipboard to remain independent.
  --  See `:help 'clipboard'`
  vim.opt.clipboard = 'unnamedplus'

  -- Enable break indent
  vim.opt.breakindent = true

  -- Save undo history
  vim.opt.undofile = true

  -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
  vim.opt.ignorecase = true
  vim.opt.smartcase = true

  -- Keep signcolumn on by default
  vim.opt.signcolumn = 'yes'

  -- Decrease update time
  vim.opt.updatetime = 250

  -- Decrease mapped sequence wait time
  -- Displays which-key popup sooner
  vim.opt.timeoutlen = 300

  -- Configure how new splits should be opened
  vim.opt.splitright = true
  vim.opt.splitbelow = true

  -- Sets how neovim will display certain whitespace characters in the editor.
  --  See `:help 'list'`
  --  and `:help 'listchars'`
  vim.opt.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

  -- Preview substitutions live, as you type!
  vim.opt.inccommand = 'split'

  -- Show which line your cursor is on
  vim.opt.cursorline = true

  -- Minimal number of screen lines to keep above and below the cursor.
  vim.opt.scrolloff = 10


  -- Set highlight on search, but clear on pressing <Esc> in normal mode
  vim.opt.hlsearch = true
end --#endregion
do  --#region Basic Keymaps
  --  See `:help vim.keymap.set()
  local setkb = vim.keymap.set
  setkb('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- Diagnostic keymaps
  setkb('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
  setkb('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
  setkb('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
  setkb('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
  -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
  -- is not what someone will guess without a bit more experience.
  --
  -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
  -- or just use <C-\><C-n> to exit terminal mode
  setkb('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- TIP: Disable arrow keys in normal mode
  setkb('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
  setkb('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
  setkb('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
  setkb('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

  if vim.g.hardmode then
    setkb('i', '<left>', '<cmd>echo "GET OUT OF INSERT MODE"<CR>')
    setkb('i', '<right>', '<cmd>echo "GET OUT OF INSERT MODE"<CR>')
    setkb('i', '<up>', '<cmd>echo "GET OUT OF INSERT MODE"<CR>')
    setkb('i', '<down>', '<cmd>echo "GET OUT OF INSERT MODE"<CR>')
  end
  -- Keybinds to make split navigation easier.
  --  Use CTRL+<hjkl> to switch between windows
  --
  --  See `:help wincmd` for a list of all window commands
  setkb('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  setkb('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  setkb('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  setkb('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
end --#endregion

do  --#region Basic Autocommands
  --  See `:help lua-guide-autocommands`

  -- Highlight when yanking (copying) text
  --  Try it with `yap` in normal mode
  --  See `:help vim.highlight.on_yank()`
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
      vim.highlight.on_yank()
    end,
  })
end --#endregion

require("image").setup({
  backend = "kitty",
  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
    },
    neorg = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      filetypes = { "norg" },
    },
    html = {
      enabled = false,
    },
    css = {
      enabled = false,
    },
  },
  max_width = nil,
  max_height = nil,
  max_width_window_percentage = nil,
  max_height_window_percentage = 50,
  window_overlap_clear_enabled = false,    -- toggles images when windows are overlapped
  window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
  editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
})
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et cc=100
