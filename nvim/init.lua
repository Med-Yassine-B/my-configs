-- Set the leader key to comma
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Auto-install lazy.nvim if it's not present
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
    -- Core plugins
    { "lewis6991/gitsigns.nvim" },
    { "nvim-lualine/lualine.nvim" },
    { "nvim-telescope/telescope.nvim" },
    { "neovim/nvim-lspconfig" },

    -- Auto-completion and Snippets
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "L3MON4D3/LuaSnip" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/cmp-nvim-lua" },

    -- Utilities
    { "windwp/nvim-autopairs" },
    { "tpope/vim-commentary" },
    { "nvim-treesitter/nvim-treesitter", branch = "main", build = ":TSUpdate" },
    { "nvim-tree/nvim-web-devicons" }, -- Required by nvim-tree.lua

    -- Terminal Images Protocol Integration
    {
        "3rd/image.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("image").setup({
                backend = "kitty", -- Uses terminal graphics protocol
                integrations = {
                    markdown = {
                        enabled = true,
                        clear_in_insert_mode = false,
                        download_remote_images = true,
                        only_render_image_at_cursor = false,
                    },
                    neorg = { enabled = true },
                },
                max_width = nil,
                max_height = nil,
                max_width_window_percentage = nil,
                max_height_window_percentage = 50,
                window_overlap_clear_enabled = true, -- Auto-clears image when a floating window covers it
            })
        end,
    },

    -- Themes
    { "folke/tokyonight.nvim" }, -- New reddish theme
    -- sessions
    { "rmagatti/auto-session" },

    -- File Explorer
    { "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" }, -- Explicit dependency
        config = function()
            require('nvim-tree').setup({
                sync_root_with_cwd=true,
                respect_buf_cwd=true,
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
        end,
    },

    -- Window Management
    { "szw/vim-maximizer",
        keys = {
            { "<C-w>m", ":MaximizerToggle<CR>", desc = "Toggle maximize window" },
        },
    },
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

    -- Mason for LSP management (Crucial for auto-installation and management)
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup() -- Initialize Mason
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" }, -- Ensure Mason is loaded first
        config = function()
            require("mason-lspconfig").setup({
                automatic_installation = true, -- Automatically installs LSPs you configure with lspconfig
                ensure_installed = { "lua_ls", "pyright", "clangd", "jdtls", "html", "cssls", "phpactor","ts_ls","omnisharp","rust_analyzer"},
            })
        end,
    },

    -- Java Development Tools Language Server (JDTLS)
    {
        "mfussenegger/nvim-jdtls",
        ft = { "java" }, -- Only load for Java files
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            local jdtls = require('jdtls')
            local home = os.getenv('HOME')

            local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
            local workspace_dir = home .. '/.local/share/nvim/jdtls-workspaces/' .. project_name

            local cmd = {
                'java',
                '-Declipse.application=org.eclipse.jdt.ls.core.id1',
                '-Dosgi.bundles.defaultStartLevel=4',
                '-Declipse.product=org.eclipse.jdt.ls.core.product',
                '-Dlog.protocol=true',
                '-Dlog.level=ALL',
                '-Xmx1G', 
                '-Xms100m', 
                '--add-modules=ALL-SYSTEM',
                '--add-opens', 'java.base/java.util=ALL-UNNAMED',
                '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
                '-jar',
                vim.fn.glob(vim.fn.stdpath('data') .. '/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar', true),
                '-configuration',
                vim.fn.stdpath('data') .. '/mason/packages/jdtls/config_linux', 
                '-data',
                workspace_dir,
            }

            local config = {
                cmd = cmd,
                settings = {
                    java = {},
                },
                on_init = function(client)
                    if not vim.loop.fs_stat(workspace_dir) then
                        vim.fn.mkdir(workspace_dir, 'p')
                    end
                end,
                on_attach = function(client, bufnr)
                end,
            }

            jdtls.start_or_attach(config)
        end,
    },

    -- Discord Rich Presence
    {
        'vyfor/cord.nvim',
        build = ':Cord update',
        opts = {
            log_level = 'error',
            editor = {
                client = 'neovim',
                tooltip = 'The Superior Text Editor',
            },
            display = {
                theme = 'catppuccin',
                flavor = 'dark',
                view = 'full',
                swap_fields = false,
                swap_icons = false,
            },

            idle = {
                details = function(opts)
                    return 'Taking a break from ' .. opts.workspace
                end,
                state = 'Be right back',
                tooltip = '😴',

            },
            text = {
                workspace = function(opts) return 'Project: ' .. opts.workspace end,
                terminal = function(opts) return 'In a terminal (' .. opts.name .. ')' end,
                editing = function(opts)
                    local text = string.format('Editing %s:%d:%d',opts.filename, opts.cursor_line, opts.cursor_char)
                    if vim.bo.modified then text = text .. ' [+]' end
                    return text
                end,
            },
            buttons = {
              {
                label = 'Github',
                url = 'https://github.com/Med-Yassine-B',
              },
            },
        },
        advanced = {
          discord = {
            reconnect = {
              enabled = true,
            },
          },
        },
    }
})

-- Auto-Sessions config
require("auto-session").setup {
  auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
  session_lens = { load_on_setup = true },
  auto_session_use_git_branch = false,
  auto_session_enable_last_session = false,
  auto_save_enabled=true,
  auto_restore_enabled=false,
  session_name_fn = function()
    return vim.fn.getcwd():gsub("/", "_")
  end,
}

-- TokyoNight Colorscheme Setup
require("tokyonight").setup({
    style = "night", 
    on_highlights = function(hl, c)
        hl.DiagnosticUnnecessary = {
            fg = c.yellow,        
            italic = false,       
        }
        hl["@lsp.type.unused"] = {
            fg = c.blue,
            italic = false,
        }
    end,
})

-- nvim-autopairs Config
require('nvim-autopairs').setup({})

-- Status Line
require('lualine').setup()

-- Git Integration
require('gitsigns').setup()

-- Fuzzy Finder
require('telescope').setup{
defaults = {
    file_ignore_patterns = {
      "%.git/",
      "build/",
      "target/", 
      "node_modules/"
    },
  }
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

-- LSP Diagnostic Configuration
vim.diagnostic.config({
    virtual_text = true,  
    signs = true,         
    float = {             
        source = "always",
        border = "rounded"
    }
})

-- Define opts for keymaps
local opts = { noremap = true, silent = true }

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
vim.cmd('set termbidi') -- Arabic support

-- Session functions
local session_dir = vim.fn.stdpath("data") .. "/sessions"

-- Deleting old session (30 days old)
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.loop.fs_stat(session_dir) then
            os.execute('find ' .. session_dir .. ' -type f -mtime +30 -delete')
        end
    end,
})

-- Key Mappings
vim.api.nvim_set_keymap('n', '<Esc>', ':nohlsearch<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", ":lua vim.lsp.buf.signature_help()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>tt", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>nn", ":AutoSession search<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>ns", ":AutoSession save<CR>", { noremap = true, silent = true })

-- Stop yank-on-delete
vim.keymap.set('n', 'd', '"_d')
vim.keymap.set('x', 'd', '"_d')

-- Error/Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>n', vim.lsp.buf.code_action, opts)

-- Disable terminal suspension
vim.keymap.set({ 'n', 'v', 'i' }, '<C-z>', '<Nop>', { desc = "Disable suspend" })

-- Code Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevelstart = 99
vim.opt.foldlevel = 99
vim.opt.foldenable=false
vim.opt.foldtext = ""

-- Colorscheme Setup
vim.cmd.colorscheme("tokyonight") 
vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])
vim.cmd([[hi NormalNC guibg=NONE ctermbg=NONE]])
vim.cmd([[hi EndOfBuffer guibg=NONE ctermbg=NONE]])

-- Bottom spacing
vim.opt.cmdheight = 0

-- Greeting Message
print("== Welcome Back Med! ==")
print("Let's start coding! 🚀")
