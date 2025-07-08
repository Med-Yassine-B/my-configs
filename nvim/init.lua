vim.g.mapleader = ","

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
--for LSPs check https://github.com/neovim/nvim-lspconfig/blob/master/lsp
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
  },

  {"szw/vim-maximizer",keys = {
    { "<C-w>m", ":MaximizerToggle<CR>", desc = "Toggle maximize window" },
  }},

  {
      "anuvyklack/windows.nvim",
      dependencies = {
        "anuvyklack/middleclass",
        "anuvyklack/animation.nvim"
      },
      config = function()
        vim.o.winwidth = 10
        vim.o.winminwidth = 10
        vim.o.equalalways = false

        require("windows").setup({
          animation = {
            enable = true,
            duration = 150,
            fps = 60,
            easing = "in_out_sine",
          }
        })
      end
  },
  {
      "rmagatti/auto-session",
      config = function()
        require("auto-session").setup({
          log_level = "error",
          auto_session_enable_last_session = false,
          auto_session_enabled = true,
          auto_save_enabled = false,
          auto_restore_enabled = false,
          auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
          auto_session_use_git_branch = true, -- optional
        })
      end,
  }

    -- {
    --   "beauwilliams/focus.nvim",
    --   config = true,
    -- },

})


--changing leader from \ to ,

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

--session functions
local session_dir = vim.fn.stdpath("data") .. "/sessions"

local function sanitize_path(path)
  -- Replace slashes with underscores for a valid filename
  return path:gsub("[/\\]", "_")
end

local function save_session()
  local cwd = vim.fn.getcwd()
  local session_name = sanitize_path(cwd)
  local session_path = session_dir .. "/" .. session_name .. ".vim"
  vim.fn.mkdir(session_dir, "p") -- create dir if missing
  vim.cmd("mksession! " .. session_path)
  print("Session saved to: " .. session_path)
end

local function list_sessions()
  local sessions = {}
  local files = vim.fn.globpath(session_dir, "*.vim", false, true)
  for _, file in ipairs(files) do
    table.insert(sessions, vim.fn.fnamemodify(file, ":t")) -- filename only
  end
  return sessions
end

local function load_session()
  local sessions = list_sessions()
  if #sessions == 0 then
    print("No sessions found!")
    return
  end

  vim.ui.select(sessions, {
    prompt = "Choose session to load:",
  }, function(choice)
    if choice then
      local path = session_dir .. "/" .. choice
      vim.cmd("source " .. path)
      print("Loaded session: " .. choice)
    else
      print("Session load cancelled.")
    end
  end)
end
--deleting old session (30 days old)
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    os.execute('find ~/.local/share/nvim/sessions/ -type f -mtime +30 -delete')
  end,
})

-- Key Mappings
vim.api.nvim_set_keymap('n', '<Esc>', ':nohlsearch<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", ":lua vim.lsp.buf.signature_help()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { noremap = true, silent = true })

--error keymapping
vim.keymap.set('n', '<leader>e', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>n', vim.lsp.buf.code_action, opts)
--sessions save/load
vim.keymap.set("n", "<leader>ss", save_session, { desc = "Save session (cwd-based name)" })
vim.keymap.set("n", "<leader>sl", load_session, { desc = "Load session from saved list" })


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
