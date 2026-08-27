-- last-used buffer toggle
vim.keymap.set("n", "<leader><leader>", "<C-^>", { desc = "Toggle last buffer" })

-- plain sequential buffer cycling (built-in, no plugin)
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- cheat sheet: parse KEYBINDINGS.md's key-bindings table and render it as
-- an aligned box-drawing table in a floating window
vim.keymap.set("n", "<leader>?", function()
  local lines = vim.fn.readfile(vim.fn.stdpath("config") .. "/KEYBINDINGS.md")

  -- pull the "| Key | Action | Source |" table out of the file
  local rows = {}
  for _, line in ipairs(lines) do
    if line:match("^|%s*%-%-%-") then
      -- header separator row, skip
    elseif line:match("^|") then
      local cells = {}
      for cell in line:gmatch("[^|]+") do
        cell = cell:gsub("`", ""):gsub("%*", ""):match("^%s*(.-)%s*$")
        table.insert(cells, cell)
      end
      table.insert(rows, cells)
    elseif #rows > 0 then
      break
    end
  end

  local ncols = #rows[1]
  local widths = {}
  for j = 1, ncols do
    widths[j] = 0
    for _, r in ipairs(rows) do
      widths[j] = math.max(widths[j], vim.fn.strdisplaywidth(r[j]))
    end
  end

  local function border(left, mid, right)
    local parts = {}
    for j = 1, ncols do
      table.insert(parts, string.rep("─", widths[j] + 2))
    end
    return left .. table.concat(parts, mid) .. right
  end

  local out, highlights = {}, {}
  table.insert(out, border("┌", "┬", "┐"))

  local function add_row(cells, is_header)
    local line, col = "│", #"│"
    for j = 1, ncols do
      local cell = cells[j] or ""
      local piece = " " .. cell .. string.rep(" ", widths[j] - vim.fn.strdisplaywidth(cell)) .. " "
      local start_col = col + 1
      if not is_header and j == 1 then
        table.insert(highlights, { #out, start_col, #cell, "Special" })
      elseif not is_header and j == ncols and (cell == "Custom" or cell == "Default") then
        local hl = cell == "Custom" and "DiagnosticOk" or "Comment"
        table.insert(highlights, { #out, start_col, #cell, hl })
      end
      line = line .. piece .. "│"
      col = col + #piece + #"│"
    end
    table.insert(out, line)
  end

  add_row(rows[1], true)
  table.insert(out, border("├", "┼", "┤"))
  for i = 2, #rows do
    add_row(rows[i], false)
  end
  table.insert(out, border("└", "┴", "┘"))

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, out)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"

  local ns = vim.api.nvim_create_namespace("cheatsheet")
  for _, h in ipairs(highlights) do
    local lnum, start_col, len, hl = h[1], h[2], h[3], h[4]
    vim.api.nvim_buf_add_highlight(buf, ns, hl, lnum, start_col, start_col + len)
  end

  local width = math.min(vim.fn.strdisplaywidth(out[1]), math.floor(vim.o.columns * 0.9))
  local height = math.min(#out, math.floor(vim.o.lines * 0.9))
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " Key bindings ",
    title_pos = "center",
  })
  vim.wo[win].wrap = false

  local close = function() vim.api.nvim_win_close(win, true) end
  vim.keymap.set("n", "q", close, { buffer = buf, nowait = true })
  vim.keymap.set("n", "<Esc>", close, { buffer = buf, nowait = true })
end, { desc = "Show key bindings cheat sheet" })

-- run the current file's spec in a marked tmux pane (e.g. a pane with a
-- shell inside the Rails container), instead of copying the path to the
-- clipboard and pasting it manually
local tmux_spec_target = nil

-- map app/**/foo.rb <-> spec/**/foo_spec.rb (a file already under spec/
-- is used as-is); lib/**/foo.rb -> spec/lib/**/foo_spec.rb
local function rspec_path_for_current_buffer()
  local abs = vim.fn.expand("%:p")
  if abs == "" then
    return nil, "buffer has no file"
  end

  local root = vim.fs.root(abs, { ".git", "Gemfile" }) or vim.fn.getcwd()
  local rel = abs:sub(#root + 2)

  if rel:match("_spec%.rb$") then
    return rel
  end
  if not rel:match("%.rb$") then
    return nil, "not a Ruby file"
  end

  if rel:match("^app/") then
    rel = "spec/" .. rel:sub(#"app/" + 1)
  elseif rel:match("^lib/") then
    rel = "spec/" .. rel
  elseif not rel:match("^spec/") then
    return nil, "don't know how to map this path to a spec"
  end

  return (rel:gsub("%.rb$", "_spec.rb"))
end

vim.keymap.set("n", "<leader>tm", function()
  if vim.env.TMUX == nil then
    vim.notify("Not running inside tmux", vim.log.levels.WARN)
    return
  end

  local raw = vim.fn.system({
    "tmux",
    "list-panes",
    "-a",
    "-F",
    "#{session_name}:#{window_index}.#{pane_index} [#{pane_current_command}] #{pane_title}",
  })
  local panes = vim.split(raw, "\n", { trimempty = true })

  vim.ui.select(panes, { prompt = "Mark tmux pane to run specs in" }, function(choice)
    if not choice then
      return
    end
    tmux_spec_target = choice:match("^%S+")
    vim.notify("Marked tmux pane: " .. tmux_spec_target)
  end)
end, { desc = "Mark tmux pane to run specs in" })

vim.keymap.set("n", "<leader>ts", function()
  if not tmux_spec_target then
    vim.notify("No tmux pane marked - run <leader>tm first", vim.log.levels.WARN)
    return
  end

  local spec_path, err = rspec_path_for_current_buffer()
  if not spec_path then
    vim.notify("Can't resolve a spec for this file: " .. err, vim.log.levels.WARN)
    return
  end

  local cmd = string.format("rake 'web:spec[%s]'", spec_path)
  vim.fn.system({ "tmux", "send-keys", "-t", tmux_spec_target, cmd, "Enter" })
  vim.notify("Sent to " .. tmux_spec_target .. ": " .. cmd)
end, { desc = "Run spec for current file in marked tmux pane" })
