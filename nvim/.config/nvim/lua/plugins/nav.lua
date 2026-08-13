return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      defaults = {
        file_ignore_patterns = { "%.git/" },
        vimgrep_arguments = {
          "rg", "--color=never", "--no-heading", "--with-filename",
          "--line-number", "--column", "--smart-case", "--hidden",
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers({ sort_mru = true, ignore_current_buffer = true })
        end,
        desc = "Find buffers (MRU)",
      },
      { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Recently opened files" },
    },
  },
  {
    "stevearc/oil.nvim",
    opts = {},
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
  },
}
