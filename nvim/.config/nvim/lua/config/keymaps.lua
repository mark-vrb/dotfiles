-- last-used buffer toggle
vim.keymap.set("n", "<leader><leader>", "<C-^>", { desc = "Toggle last buffer" })

-- plain sequential buffer cycling (built-in, no plugin)
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- cheat sheet: show this config's README key-bindings table in a floating window
vim.keymap.set("n", "<leader>?", function()
  local lines = vim.fn.readfile(vim.fn.stdpath("config") .. "/README.md")

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " Key bindings (README.md) ",
    title_pos = "center",
  })
  vim.wo[win].wrap = false

  local close = function() vim.api.nvim_win_close(win, true) end
  vim.keymap.set("n", "q", close, { buffer = buf, nowait = true })
  vim.keymap.set("n", "<Esc>", close, { buffer = buf, nowait = true })

  vim.fn.search("Key bindings quick reference")
  vim.cmd("normal! zt")
end, { desc = "Show key bindings cheat sheet" })
