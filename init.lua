
-- Set up basic settings
vim.o.number = true               -- Show line numbers
vim.o.relativenumber = false       -- Relative line numbers
vim.o.smartindent = true         -- Smart indentation
vim.o.tabstop = 4                -- Number of spaces for a tab
vim.o.shiftwidth = 4             -- Number of spaces for an indentation level
vim.o.expandtab = true           -- Use spaces instead of tabs
vim.o.smarttab = true            -- Use smart tabs
vim.o.autoindent = true          -- Automatically indent new lines
vim.o.wrap = false               -- Don't wrap lines
vim.o.clipboard = "unnamedplus"  -- Use system clipboard

vim.cmd("colorscheme default")
--desabling terminal mode
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

vim.g.python3_host_prog ='/home/bouzidi/venvPython/bin/python3'



-- Enable mouse support
vim.o.mouse = "a"

-- Set colorscheme
--vim.cmd("colorscheme desert")  -- Change 'desert' to your preferred colorscheme

-- Plugin manager setup (packer.nvim)
-- You can install packer.nvim if you don't have it yet
-- Run this command to install packer: git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

require("packer").startup(function()
  -- Packer can manage itself
  use "wbthomason/packer.nvim"

  -- Install useful plugins here
  use "neovim/nvim-lspconfig"      -- LSP support
  use "hrsh7th/nvim-compe"         -- Auto-completion
  use "nvim-treesitter/nvim-treesitter" -- Treesitter for better syntax highlighting
  use "tpope/vim-fugitive"         -- Git integration
  use "vim-airline/vim-airline"    -- Statusline
  use "nvim-telescope/telescope.nvim"  -- File search and more
end)

-- LSP configuration (optional)
local lspconfig = require("lspconfig")
lspconfig.pyright.setup{}          -- Python LSP
lspconfig.ts_ls.setup{}            -- TypeScript LSP (updated name)
lspconfig.clangd.setup{}           -- C/C++ LSP

-- Treesitter setup
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"python", "javascript", "cpp", "lua"},  -- Example list of languages
  highlight = {
    enable = true,                 -- Enable syntax highlighting
  },
}

-- Auto-completion setup (optional)
vim.o.completeopt = "menuone,noselect"

-- Key mappings (optional)
vim.api.nvim_set_keymap("n", "<Leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true })

-- Additional settings and custom configurations
