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
            return
          end

          -- Rails route `to: 'controller/path#action'` convention: the
          -- controller lives at `<controller/path>_controller.rb`, possibly
          -- inside an engine's own app/controllers rather than the main
          -- app's, so search for it instead of assuming a fixed prefix
          local controller_path, action = cfile:match("^([%w_/]+)#([%w_!?]+)$")
          if controller_path then
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            require("telescope.builtin").find_files({
              default_text = controller_path .. "_controller.rb",
              attach_mappings = function(_, map)
                actions.select_default:replace(function(prompt_bufnr)
                  local selection = action_state.get_selected_entry()
                  actions.close(prompt_bufnr)
                  if selection then
                    vim.cmd.edit(selection.path or selection[1])
                    vim.fn.search("\\<def\\s\\+" .. action .. "\\>", "w")
                  end
                end)
                return true
              end,
            })
            return
          end

          -- not resolvable as a real path from here (e.g. no LSP/isfname
          -- context) - hand it to Telescope pre-filled instead of forcing
          -- a yank-then-paste-into-prompt round trip through the system clipboard
          require("telescope.builtin").find_files({ default_text = cfile })
        end,
        desc = "Go to file under cursor, or route's controller#action (fallback: Telescope find_files)",
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
