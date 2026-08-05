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
