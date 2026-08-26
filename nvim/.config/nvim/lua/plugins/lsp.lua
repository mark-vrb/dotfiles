return {
  {
    "mason-org/mason.nvim",
    opts = {
      -- non-LSP tools (formatters/linters) also installed through mason
      -- rubocop intentionally excluded: it should track the active rbenv/bundler
      -- toolchain per-project (see rustfmt for the same reasoning), not a
      -- global always-latest Mason copy that can crash on older rubocop
      -- extension gems (rubocop-capybara, rubocop-rspec, etc.)
      ensure_installed = { "prettier" },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = {
        "ruby_lsp",       -- Ruby / Rails
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

      -- track progress (e.g. ruby_lsp indexing a large Rails codebase) for the
      -- statusline in config/options.lua, and force a redraw so it's visible
      -- immediately rather than waiting for the next natural redraw
      vim.api.nvim_create_autocmd("LspProgress", {
        callback = function(args)
          require("config.lsp_status").on_progress(args.data.client_id, args.data.params.token, args.data.params.value)
          vim.cmd.redrawstatus()
        end,
      })

      -- don't leave a stale "Indexing: 54%" behind if a client detaches or
      -- crashes mid-report without ever sending an "end" progress event
      vim.api.nvim_create_autocmd("LspDetach", {
        callback = function(args)
          require("config.lsp_status").clear_client(args.data.client_id)
          vim.cmd.redrawstatus()
        end,
      })
    end,
  },
}
