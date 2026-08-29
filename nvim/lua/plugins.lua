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
    {'neoclide/vim-jsx-improve'},
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
    { "folke/tokyonight.nvim",
        opts={
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
        }
    }, -- New reddish theme
    -- sessions
    { "rmagatti/auto-session",

        opts={
          auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
          session_lens = { load_on_setup = true },
          auto_session_use_git_branch = false,
          auto_session_enable_last_session = false,
          auto_save_enabled=false,
          auto_restore_enabled=false,
          cwd_change_handling=true,
          session_name_fn = function()
            return vim.fn.getcwd():gsub("/", "_")
          end,
          pre_restore_cmds={
              function ()
                Save_session()
              end
          },
          post_restore_cmds={
              function ()
                  local cwd=vim.fn.getcwd()
                  if not vim.uv.fs_stat(cwd) then
                    vim.notify("Failed getting cwd!")
                    return
                  end

                  vim.env.WORKSPACE=cwd
              end
          }
        },
    },

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
                theme = 'default',
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
    }),
    on_init = function(client)
    local join = vim.fs.joinpath
    local path = client.workspace_folders[1].name

    -- Don't do anything if there is project local config
    if vim.uv.fs_stat(join(path, '.luarc.json'))
      or vim.uv.fs_stat(join(path, '.luarc.jsonc'))
    then
      return
    end

    local nvim_settings = {
      runtime = {
        -- Tell the language server which version of Lua you're using
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'}
      },
      workspace = {
        checkThirdParty = false,
        library = {
          -- Make the server aware of Neovim runtime files
          vim.env.VIMRUNTIME,
          vim.fn.stdpath('config'),
        },
      },
    }

    client.config.settings.Lua = vim.tbl_deep_extend(
      'force',
      client.config.settings.Lua,
      nvim_settings
    )
  end,
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
