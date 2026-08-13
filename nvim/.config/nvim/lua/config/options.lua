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
