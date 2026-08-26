-- Persistent LSP progress for the statusline.
--
-- vim.lsp.status() drains each client's progress ring buffer on every call,
-- so it only reports a message on the one redraw right after it arrives (see
-- the LspProgress autocmd in plugins/lsp.lua and the statusline in
-- config/options.lua) - normal redraws in between (cursor moves, mode
-- changes, ...) find nothing new and go blank. This module instead keeps
-- the *last* message per (client, token) around until its matching "end"
-- event, so e.g. "54%: Indexing" stays visible the whole time a big Rails
-- codebase is being indexed, not just on the redraw where it changed.

local M = {}

-- keyed by "<client_id>:<token>" -> { title, message, percentage }
M._entries = {}
-- insertion order, so rendering multiple concurrent progress streams is stable
M._order = {}

local function key(client_id, token)
  return client_id .. ":" .. tostring(token)
end

--- Handle one LSP $/progress value for a given client/token.
--- @param client_id number
--- @param token integer|string
--- @param value table lsp.WorkDoneProgressBegin|Report|End
function M.on_progress(client_id, token, value)
  if type(value) ~= "table" or not value.kind then
    return
  end

  local k = key(client_id, token)

  if value.kind == "end" then
    if M._entries[k] then
      M._entries[k] = nil
      for i, existing in ipairs(M._order) do
        if existing == k then
          table.remove(M._order, i)
          break
        end
      end
    end
    return
  end

  if not M._entries[k] then
    table.insert(M._order, k)
    M._entries[k] = {}
  end
  local entry = M._entries[k]
  entry.title = value.title or entry.title
  entry.message = value.message
  entry.percentage = value.percentage
end

--- Drop everything tracked for a client - used on LspDetach so a client that
--- crashes mid-report doesn't leave a stale "Indexing: 54%" forever.
--- @param client_id number
function M.clear_client(client_id)
  local prefix = key(client_id, "")
  for i = #M._order, 1, -1 do
    local k = M._order[i]
    if k:sub(1, #prefix) == prefix then
      M._entries[k] = nil
      table.remove(M._order, i)
    end
  end
end

--- Render current progress for the statusline.
--- @return string
function M.render()
  local parts = {}
  for _, k in ipairs(M._order) do
    local entry = M._entries[k]
    local message
    if entry.title and entry.message then
      message = entry.title .. ": " .. entry.message
    else
      message = entry.message or entry.title or ""
    end
    if entry.percentage then
      message = string.format("%d%%: %s", entry.percentage, message)
    end
    table.insert(parts, message)
  end
  return table.concat(parts, ", ")
end

--- Reset all tracked state. Used by tests.
function M._reset()
  M._entries = {}
  M._order = {}
end

return M
