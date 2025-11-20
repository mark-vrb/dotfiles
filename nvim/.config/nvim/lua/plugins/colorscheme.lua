return {
  -- tokyonight night
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "night" },
  },

  -- add gruvbox
  { "ellisonleao/gruvbox.nvim", name = "gruvbox" },

  -- add catppuccin
  { "catppuccin/nvim", name = "catppuccin" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
