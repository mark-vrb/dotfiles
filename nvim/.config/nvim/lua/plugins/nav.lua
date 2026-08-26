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
      {
        "gf",
        function()
          local cfile = vim.fn.expand("<cfile>")
          if cfile == "" then
            return
          end
          local found = vim.fn.findfile(cfile, vim.o.path)
          if found == "" then
            found = vim.fn.finddir(cfile, vim.o.path)
          end
          if found ~= "" then
            vim.cmd.edit(found)
          else
            -- not resolvable as a real path from here (e.g. no LSP/isfname
            -- context) - hand it to Telescope pre-filled instead of forcing
            -- a yank-then-paste-into-prompt round trip through the system clipboard
            require("telescope.builtin").find_files({ default_text = cfile })
          end
        end,
        desc = "Go to file under cursor (fallback: Telescope find_files)",
      },
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
