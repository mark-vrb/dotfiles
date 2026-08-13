return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "ruby", "python", "rust", "typescript", "tsx",
      "html", "css", "astro", "lua", "vim", "bash", "json", "yaml",
    },
  },
  config = function(_, opts)
    require("nvim-treesitter").install(opts.ensure_installed)

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        if not pcall(vim.treesitter.start) then
          return
        end
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
