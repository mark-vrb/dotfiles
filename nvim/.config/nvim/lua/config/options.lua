local o = vim.opt

-- leader
vim.g.mapleader = " "

-- UI
o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.wrap = false
o.scrolloff = 8
o.termguicolors = true
o.splitright = true
o.splitbelow = true

-- statusline: default layout plus LSP progress (e.g. ruby_lsp indexing a
-- large Rails app) so it's visible when navigation/completion may be stale.
-- Uses config/lsp_status.lua rather than vim.lsp.status() directly, since
-- that drains its progress messages on read and would only flash briefly.
o.statusline = "%f %h%w%m%r%=%{v:lua.require'config.lsp_status'.render()} %-14.14(%l,%c%V%) %P"

-- editing
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.ignorecase = true
o.smartcase = true
o.updatetime = 250

-- theme: hardcoded light, no OS sync
vim.o.background = "light"
vim.cmd.colorscheme("default")
