-------------------------------------------------------------------------------
-- Mappings
-------------------------------------------------------------------------------
-- toggle showing spaces
vim.keymap.set("n", "<leader>l", ":set nolist!<CR>", { silent = true })

-- silence search highlight
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { silent = true })

-- turn on paste quickly
vim.keymap.set("n", "<leader>p", ":set paste!<CR>", { silent = true })

-- remove trailing spaces
vim.keymap.set("n", "<leader>c", ":%s/\\s\\+$//<CR>", { silent = true })

-- Exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")
