return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {
          cmd = { vim.fn.expand("~/.rbenv/shims/ruby-lsp") },
        },
        rubocop = {
          cmd = { vim.fn.expand("~/.rbenv/shims/rubocop"), "--lsp" },
        },
      },
    },
  },
}
