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
        "<leader>fc",
        function()
          local base = "main"
          if vim.fn.system("git rev-parse --verify main 2>/dev/null") == "" then
            base = "master"
          end
          local merge_base = vim.trim(vim.fn.system({ "git", "merge-base", "HEAD", base }))
          if vim.v.shell_error ~= 0 then
            vim.notify("Not in a git repo, or no '" .. base .. "' branch found", vim.log.levels.WARN)
            return
          end

          require("telescope.pickers").new({}, {
            prompt_title = "Changed Files (vs " .. base .. ")",
            finder = require("telescope.finders").new_oneshot_job(
              { "git", "diff", "--name-only", merge_base },
              { entry_maker = require("telescope.make_entry").gen_from_file({}) }
            ),
            sorter = require("telescope.config").values.file_sorter({}),
            previewer = require("telescope.config").values.file_previewer({}),
          }):find()
        end,
        desc = "Find files changed on this branch",
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
