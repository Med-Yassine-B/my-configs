-- Set the leader key to comma
vim.g.mapleader = ","
vim.g.maplocalleader = ","

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
