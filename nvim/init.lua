
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
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-tree/nvim-web-devicons" }, -- Required by nvim-tree.lua

    -- Themes
    { "folke/tokyonight.nvim" }, -- New reddish theme
    -- sessions
    {"rmagatti/auto-session"},

    -- File Explorer
    { "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" }, -- Explicit dependency
        config = function()
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
        end,
    },

    -- Window Management
    {"szw/vim-maximizer",
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
                -- You can also list specific servers to ensure they are installed:
                 ensure_installed = { "lua_ls", "pyright", "clangd", "jdtls", "html", "cssls", "phpactor","ts_ls"},
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

            -- Define a workspace directory for JDTLS.
            -- It's highly recommended to use a project-specific workspace.
            -- This example uses a directory inside your nvim data path,
            -- named after the current project's directory.
            local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
            local workspace_dir = home .. '/.local/share/nvim/jdtls-workspaces/' .. project_name

            -- Define the command to start jdtls with memory limits
            local cmd = {
                'java',
                '-Declipse.application=org.eclipse.jdt.ls.core.id1',
                '-Dosgi.bundles.defaultStartLevel=4',
                '-Declipse.product=org.eclipse.jdt.ls.core.product',
                '-Dlog.protocol=true',
                '-Dlog.level=ALL',
                '-Xmx1G', -- Set max heap size to 1GB (adjust as needed, e.g., 512M, 2G)
                '-Xms100m', -- Set initial heap size to 100MB
                '--add-modules=ALL-SYSTEM',
                '--add-opens', 'java.base/java.util=ALL-UNNAMED',
                '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
                '-jar',
                vim.fn.glob(vim.fn.stdpath('data') .. '/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar', true),
                '-configuration',
                vim.fn.stdpath('data') .. '/mason/packages/jdtls/config_linux', -- Or config_mac/config_win
                '-data',
                workspace_dir,
            }

            -- JDTLS configuration table
            local config = {
                cmd = cmd,
                -- root_dir = jdtls.util.find_root({'.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle'}),
                settings = {
                    java = {
                        -- Add any specific Java settings here if needed
                        -- For example, to disable null analysis if it causes issues
                        -- compile = { nullAnalysis = { mode = "disabled" } },
                    },
                },
                -- Ensure the workspace directory exists
                on_init = function(client)
                    if not vim.loop.fs_stat(workspace_dir) then
                        vim.fn.mkdir(workspace_dir, 'p')
                    end
                end,
                on_attach = function(client, bufnr)
                    -- You can add keybindings or other on_attach logic here
                    -- For example, to discover main classes for debugging (if nvim-dap is set up)
                    -- require("jdtls.dap").setup_dap_main_class_configs()
                end,
            }

            -- Start or attach JDTLS
            jdtls.start_or_attach(config)
        end,
    },
})
-- Auto-Sessions config
require("auto-session").setup {
  auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
  session_lens = { load_on_setup = true },
  auto_session_use_git_branch = false,
  auto_session_enable_last_session = false,
  auto_save_enabled=true,
  auto_restore_enabled=true,
  session_name_fn = function()
    return vim.fn.getcwd():gsub("/", "_")
  end,
}

-- TokyoNight Colorscheme Setup
require("tokyonight").setup({
    style = "night", -- Or "moon", "storm", "day"
    on_highlights = function(hl, c)
        hl.DiagnosticUnnecessary = {
            fg = c.yellow,        -- Change this to any bright color you prefer
            italic = false,       -- Disable italic if it's hard to read
        }
        hl["@lsp.type.unused"] = {
            fg = c.blue,
            italic = false,
        }
        -- hl.Comment = {
        --    fg = "#a9ffd6",
        --    italic = true, -- optional
        -- }
    end,
})

-- nvim-autopairs Config
require('nvim-autopairs').setup({})

-- Status Line
require('lualine').setup()

-- Git Integration
require('gitsigns').setup()

-- Fuzzy Finder
require('telescope').setup()

-- LSP Config
local succes, lspconfig = pcall(require, 'lspconfig')
if succes then

    -- JS/TS Language Server
lspconfig.ts_ls.setup({
    on_attach = function(client, bufnr)
        -- Disable tsserver formatting if you use another formatter (like prettier)
        client.server_capabilities.documentFormattingProvider = false
    end
})
    -- Lua Language Server
    lspconfig.lua_ls.setup({
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                    path = vim.split(package.path, ';'),
                },
                diagnostics = {
                    globals = {'vim'},
                },
                workspace = {
                    -- Only index your Neovim runtime files (plus current project files)
                    library = {
                        vim.api.nvim_get_runtime_file("", true),
                        vim.loop.cwd(),  -- add current working directory explicitly
                    },
                    checkThirdParty = false,
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    })
    -- Python Language Server
    lspconfig.pyright.setup{}
    -- C/C++ Language Server
    lspconfig.clangd.setup{
        cmd = {"clangd", "--compile-commands-dir", "build"}
    }
    -- HTML Language Server
    lspconfig.html.setup{
        cmd = { "vscode-html-language-server", "--stdio" },
    }
    -- CSS Language Server
    lspconfig.cssls.setup{}
    -- PHP Language Server
    lspconfig.phpactor.setup{}

    -- JDTLS setup will be handled by mason-lspconfig.
    -- If you need specific JDTLS configurations, you would add them here:
    -- lspconfig.jdtls.setup {
    --   -- Your JDTLS specific settings like `cmd` for the server, `root_dir`, etc.
    --   -- Mason-lspconfig usually provides good defaults, but you can override.
    -- }
end

-- Treesitter Config
require'nvim-treesitter.configs'.setup {
    -- ensure_installed = { "java", "lua", "cpp", "python", "c", "javascript", "php", "html", "css" }, -- Uncomment and run :TSUpdate if you want to auto-install these
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    -- auto_install=false,
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

-- LSP Diagnostic Configuration (shows errors/warnings)
vim.diagnostic.config({
    virtual_text = true,  -- Shows error/warning text inline
    signs = true,         -- Shows signs in the gutter (E, W, etc.)
    float = {             -- Shows floating window with details on hover
        source = "always",
        border = "rounded"
    }
})

-- Define opts for keymaps (was missing)
local opts = { noremap = true, silent = true }

-- General Settings
vim.o.relativenumber = false -- Set to true if you prefer relative line numbers
vim.o.smartindent = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.wrap = false
vim.o.mouse = "a"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.number = true -- Set to false if you prefer no line numbers at all
vim.cmd('set termbidi') -- Arabic support

-- Session functions
local session_dir = vim.fn.stdpath("data") .. "/sessions"

-- Deleting old session (30 days old)
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        -- Ensure the directory exists before attempting to delete files
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

-- Error/Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>n', vim.lsp.buf.code_action, opts)


-- Code Folding
vim.o.foldmethod = "indent"
vim.o.foldlevel = 99

-- Colorscheme Setup (ensure it's called after all highlights are set up)
vim.cmd.colorscheme("tokyonight") -- Set TokyoNight Night theme (reddish variant)
vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])
vim.cmd([[hi NormalNC guibg=NONE ctermbg=NONE]])
vim.cmd([[hi EndOfBuffer guibg=NONE ctermbg=NONE]])

-- Greeting Message
print("== Welcome Back Med! ==")
print("Let's start coding! 🚀")
