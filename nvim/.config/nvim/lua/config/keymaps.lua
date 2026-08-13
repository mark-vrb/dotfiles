-- last-used buffer toggle
vim.keymap.set("n", "<leader><leader>", "<C-^>", { desc = "Toggle last buffer" })

-- plain sequential buffer cycling (built-in, no plugin)
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
