return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function() require("conform").format({ async = true, lsp_fallback = true }) end,
      desc = "Format buffer",
    },
  },
  opts = function()
    return {
      formatters_by_ft = {
        ruby = { "rubocop" },
        rust = { "rustfmt" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        astro = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
      format_on_save = {
        timeout_ms = 1500,
        lsp_fallback = true,
      },
      formatters = {
        rustfmt = {
          -- respects rustfmt.toml / edition in Cargo.toml automatically
          prepend_args = {},
        },
        rubocop = {
          command = "bundle",
          args = { "exec", "rubocop", "-A", "--stderr", "--force-exclusion", "--stdin", "$FILENAME" },
          cwd = require("conform.util").root_file({ "Gemfile" }),
        },
      },
    }
  end,
}
