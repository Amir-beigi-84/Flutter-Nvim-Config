-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- replace visual selection with default register without yanking
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<Tab>", "<cmd>bn<cr>")
vim.keymap.set("n", "<S-Tab>", "<cmd>bp<cr>")
-- source .nvim.lua
vim.keymap.set("n", "<leader>S", "<cmd>so .nvim.lua<cr>")

vim.keymap.set("n", "zz", "<cmd>normal! zMzv<cr>", { desc = "Fold all others" })

-- Load Flutter keymaps
require("config.flutter-keymaps")

