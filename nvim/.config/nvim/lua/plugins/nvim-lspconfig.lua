return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {
          cmd = { "bundle", "exec", "ruby-lsp" },
        },
        rubocop = {
          cmd = { "bundle", "exec", "rubocop", "--lsp", "--config", ".rubocop_trans.yml" },
        },
      },
    },
  },
}
