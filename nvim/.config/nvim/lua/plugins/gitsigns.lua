return {
  "lewis6991/gitsigns.nvim",
  opts = {
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
  },
  keys = {
    { "]h", function() require("gitsigns").next_hunk() end, desc = "Next hunk" },
    { "[h", function() require("gitsigns").prev_hunk() end, desc = "Prev hunk" },
    { "<leader>hp", function() require("gitsigns").preview_hunk() end, desc = "Preview hunk" },
    { "<leader>hs", function() require("gitsigns").stage_hunk() end, desc = "Stage hunk" },
    { "<leader>hr", function() require("gitsigns").reset_hunk() end, desc = "Reset hunk" },
    { "<leader>hb", function() require("gitsigns").blame_line() end, desc = "Blame line" },
  },
}
