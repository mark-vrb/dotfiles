return {
  {
    "mason-org/mason.nvim",
    opts = {
      -- non-LSP tools (formatters/linters) also installed through mason
      ensure_installed = { "rubocop", "prettier" },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = {
        "ruby_lsp",       -- Ruby / Rails
        "rubocop",        -- also registered here as an LSP-adjacent diagnostic source
        "basedpyright",   -- Python
        "rust_analyzer",  -- Rust
        "ts_ls",          -- TypeScript / JS
        "html",
        "cssls",
        "tailwindcss",    -- drop if not using Tailwind
        "astro",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            check = { command = "clippy" },
          },
        },
      })

      vim.lsp.config("ruby_lsp", {
        init_options = { formatter = "auto" },
      })

      vim.lsp.config("basedpyright", {
        settings = {
          basedpyright = { analysis = { typeCheckingMode = "standard" } },
        },
      })

      vim.diagnostic.config({
        virtual_text = { prefix = "●", spacing = 2 },
        severity_sort = true,
        float = { border = "rounded" },
      })

      -- Neovim 0.11+ already sets these globally on LSP attach, so we don't redefine them:
      --   grn -> rename, gra -> code action, grr -> references,
      --   gri -> implementation, grt -> type definition, gO -> document symbols,
      --   K -> hover, <C-s> (insert mode) -> signature help
      -- gd has no built-in default, so it's the only one worth adding ourselves.
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = args.buf })
        end,
      })
    end,
  },
}
