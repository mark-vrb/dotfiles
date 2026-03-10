return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      rubocop = {
        command = "bundle",
        args = { "exec", "rubocop", "--auto-correct-all", "-f", "quiet", "--stderr", "--stdin", "$FILENAME" },
        stdin = true,
        cwd = require("conform.util").root_file({ "Gemfile" }),
      },
    },
  },
}
