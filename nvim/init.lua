local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin Manager Setup (lazy.nvim)
require("lazy").setup({
  { "lewis6991/gitsigns.nvim" },
  { "nvim-lualine/lualine.nvim" },
  { "nvim-telescope/telescope.nvim" },
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "L3MON4D3/LuaSnip" },
  { "windwp/nvim-autopairs" },
  { "tpope/vim-commentary" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "hrsh7th/cmp-cmdline" },
  { "hrsh7th/cmp-nvim-lua" },
  { "folke/tokyonight.nvim" }, -- New reddish theme
  { "nvim-tree/nvim-web-devicons" },
  { "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
}
})

require("tokyonight").setup({
  on_highlights = function(hl, c)
    hl.DiagnosticUnnecessary = {
      fg = c.yellow,        -- change this to any bright color you prefer
      italic = false,     -- disable italic if it's hard to read
    }
    hl["@lsp.type.unused"] = {
      fg = c.blue,
      italic = false,
    }
    -- hl.Comment = {
    --   fg = "#a9ffd6",
    --   italic = true, -- optional
    -- }
  end,
})

require('nvim-tree').setup({
    view = {
          width = 30,
          side = "left",
        },
        filters = {
          dotfiles = false,
        },
        git = {
          enable = true,
        },
        actions = {
    open_file = {
      quit_on_open = true,
    },
  },
})
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- nvim-autopairs Config
require('nvim-autopairs').setup({})

-- Status Line
require('lualine').setup()

-- Git Integration
require('gitsigns').setup()

-- Fuzzy Finder
require('telescope').setup()

-- LSP Config
local succes,lspconfig = pcall(require,'lspconfig')
if succes then
    lspconfig.pyright.setup{}
    lspconfig.clangd.setup{
        cmd = {"clangd", "--compile-commands-dir", "build"}

    }
    --DISABLED JS/TS LANGUAGE SERVER
    -- lspconfig.ts_ls.setup{
    --     init_options = {
    --         hostInfo = "neovim",
    --         disableSuggestions = true,
    --         preferences = {
    --             includePackageJsonAutoImports = "off",
    --         },
    --     },
    --     settings = {
    --         typescript = {
    --             tsserver = {
    --             -- maxTsServerMemory = 100, -- limit memory
    --             },
    --             referencesCodeLens = {
    --                 enabled = false,
    --             },
    --         },
    --         javascript = {
    --             implicitProjectConfig = {
    --                 checkJs = false,
    --             }
    --         },
    --     }
    -- }
    -- lspconfig.tsserver.setup{}
    lspconfig.html.setup{
        cmd = { "vscode-html-language-server", "--stdio" },
    }
    lspconfig.cssls.setup{}
    lspconfig.phpactor.setup{}
end

-- Treesitter Config
require'nvim-treesitter.configs'.setup {
--   -- ensure_installed = { "java", "lua", "cpp", "python", "c", "javascript", "php", "html", "css" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
--   -- auto_install=false,
}

-- Auto-completion Setup
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      require'luasnip'.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'luasnip' },
  })
})
-- LSP Shows ERRORS 
 vim.diagnostic.config({
     virtual_text = true,  -- Shows error/warning text inline
     signs = true,         -- Shows signs in the gutter (E, W, etc.)
     float = {             -- Shows floating window with details on hover
         source = "always", 
         border = "rounded"
     }
 })
-----------------------------------


-- General Settings
vim.o.relativenumber = false
vim.o.smartindent = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.wrap = false
vim.o.mouse = "a"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.number = true
--arabic support
vim.cmd('set termbidi')
-- السلام عليكم

-- Key Mappings
vim.api.nvim_set_keymap('n', '<Esc>', ':nohlsearch<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", ":lua vim.lsp.buf.signature_help()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { noremap = true, silent = true })


--error keymapping
vim.keymap.set('n', '<leader>e', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>n', vim.lsp.buf.code_action, opts)

-- Code Folding
vim.o.foldmethod = "indent"
vim.o.foldlevel = 99

-- Colorscheme Setup
vim.cmd.colorscheme("tokyonight") -- Set TokyoNight Night theme (reddish variant)
vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])
vim.cmd([[hi NormalNC guibg=NONE ctermbg=NONE]])
vim.cmd([[hi EndOfBuffer guibg=NONE ctermbg=NONE]])

-- Greeting Message
print("== Welcome Back Med! ==")
print("Let's start coding! 🚀")
