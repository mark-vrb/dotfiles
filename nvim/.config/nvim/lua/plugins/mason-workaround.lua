-- TODO: remove this when lazyvim fixes the original issue
-- https://github.com/LazyVim/LazyVim/issues/6039
-- Background: mason update to v2 broke some lazyvim configs

return {
  { "mason-org/mason.nvim", version = "^1.0.0" },
  { "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },
}
