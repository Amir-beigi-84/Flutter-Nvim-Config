return {
  {
    "zaldih/themery.nvim",
    lazy = false,
    priority = 1001,
    config = function()
      require("themery").setup({
        themes = {
          { name = "Kanagawa", colorscheme = "kanagawa" },

          {
            name = "TokyoNight Moon",
            colorscheme = "tokyonight",
            before = [[ pcall(function() require("tokyonight").setup({ style = "moon", transparent = false }) end) ]],
          },

          {
            name = "Catppuccin Mocha",
            colorscheme = "catppuccin",
            before = [[ pcall(function() require("catppuccin").setup({ flavour = "mocha" }) end) ]],
          },

          {
            name = "Carbonfox (Nightfox)",
            colorscheme = "carbonfox",
            before = [[ pcall(function() require("nightfox").setup({}) end) ]],
          },

          { name = "Nord", colorscheme = "nord" },

          {
            name = "OneDark Deep",
            colorscheme = "onedark",
            before = [[ pcall(function() require("onedark").setup({ style = "deep" }) end) ]],
          },

          { name = "Everforest", colorscheme = "everforest" },

          {
            name = "Gruvbox Hard",
            colorscheme = "gruvbox",
            before = [[ pcall(function() require("gruvbox").setup({ contrast = "hard", transparent_mode = false }) end) ]],
          },

          { name = "Oxocarbon", colorscheme = "oxocarbon" },

          {
            name = "GitHub Dark Default",
            colorscheme = "github_dark_default",
            before = [[ pcall(function() require("github-theme").setup({ options = { transparent = false } }) end) ]],
          },

          { name = "Monokai", colorscheme = "monokai" },
          { name = "Dracula", colorscheme = "dracula" },

          -- maxmx03/solarized.nvim uses this colorscheme id:
          { name = "Solarized Osaka", colorscheme = "solarized-osaka" },
        },

        livePreview = true,
      })
    end,
  },

  -- Make sure these themes are installed (lazy-load is fine)
  { "rebelot/kanagawa.nvim", lazy = true },
  { "folke/tokyonight.nvim", lazy = true },
  { "catppuccin/nvim", name = "catppuccin", lazy = true },
  { "EdenEast/nightfox.nvim", lazy = true }, -- provides carbonfox
  { "shaunsingh/nord.nvim", lazy = true },
  { "navarasu/onedark.nvim", lazy = true },
  { "sainnhe/everforest", lazy = true },
  { "ellisonleao/gruvbox.nvim", lazy = true },
  { "nyoom-engineering/oxocarbon.nvim", lazy = true },
  { "projekt0n/github-nvim-theme", lazy = true },
  { "tanvirtin/monokai.nvim", lazy = true },
  { "Mofiqul/dracula.nvim", lazy = true },
  { "maxmx03/solarized.nvim", lazy = true },
}
