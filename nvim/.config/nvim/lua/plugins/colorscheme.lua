return {
  -- tokyonight night
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "night" },
  },

  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },

  -- add catppuccin
  { "catppuccin/nvim", name = "catppuccin" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
