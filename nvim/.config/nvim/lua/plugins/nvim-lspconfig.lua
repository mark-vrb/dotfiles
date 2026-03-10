return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {
          cmd = { vim.fn.expand("~/.rbenv/shims/ruby-lsp") },
        },
        rubocop = {
          cmd = { "bundle", "exec", "rubocop", "--lsp", "--config", ".rubocop_trans.yml" },
        },
      },
    },
  },
}
