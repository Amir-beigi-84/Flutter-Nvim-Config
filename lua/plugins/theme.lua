-- ~/.config/nvim/lua/plugins/theme-switcher.lua
return {
  -- Pickers (optional but nice)
  { "nvim-telescope/telescope.nvim", lazy = true },

  -- Sharp & aesthetic themes (well-maintained, good contrast)
  { "folke/tokyonight.nvim", lazy = true, opts = { style = "moon" } },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = { flavour = "mocha", integrations = { lsp_trouble = true } },
  },
  { "EdenEast/nightfox.nvim", lazy = true }, -- includes carbonfox, nordfox, etc.
  { "rebelot/kanagawa.nvim", lazy = true },
  { "shaunsingh/nord.nvim", lazy = true },
  {
    "navarasu/onedark.nvim",
    lazy = true,
    opts = { style = "darker" },
  },
  { "sainnhe/everforest", lazy = true },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    opts = { contrast = "hard" },
  },
  { "nyoom-engineering/oxocarbon.nvim", lazy = true },
  {
    "projekt0n/github-nvim-theme",
    lazy = true,
    opts = { theme_style = "dark_default" },
  },
  { "tanvirtin/monokai.nvim", lazy = true },
  { "Mofiqul/dracula.nvim", lazy = true },
  { "maxmx03/solarized.nvim", lazy = true },

  -- our tiny switcher “glue”
  {
    -- no external repo: load our utils when UI starts
    dir = vim.fn.stdpath("config") .. "/lua/local_theme_switcher",
    dev = true,
    lazy = false,
    cond = function()
      return vim.loop.fs_stat(
        vim.fn.stdpath("config") .. "/lua/local_theme_switcher/init.lua"
      )
    end,
    config = function()
      require("local_theme_switcher").setup()
    end,
  },
}
