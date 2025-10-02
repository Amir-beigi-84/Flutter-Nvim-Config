-- ~/.config/nvim/init.lua
-- Keep these pcall'd so a typo in one file doesn't block plugin bootstrap.
pcall(require, "config.options")
pcall(require, "config.keymaps")
pcall(require, "config.autocmds")

-- Bootstrap lazy.nvim + load LazyVim and your plugin specs.
-- This must exist: ~/.config/nvim/lua/config/lazy.lua
require("config.lazy")

-- Quick sanity: pick a default colorscheme if available
vim.schedule(function()
  pcall(vim.cmd, "colorscheme tokyonight")
end)
