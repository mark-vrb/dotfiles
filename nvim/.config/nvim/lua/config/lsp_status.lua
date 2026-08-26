-- Persistent LSP progress for the statusline.
--
-- vim.lsp.status() drains each client's progress ring buffer on every call,
-- so it only reports a message on the one redraw right after it arrives (see
-- the LspProgress autocmd in plugins/lsp.lua and the statusline in
-- config/options.lua) - normal redraws in between (cursor moves, mode
-- changes, ...) find nothing new and go blank. This module instead keeps
-- the *last* progress per (client, token) around until its matching "end"
-- event, so e.g. "54% ruby_lsp: indexing" stays visible the whole time a
-- big Rails codebase is being indexed, not just on the redraw where it
-- changed - rendered short, since the percentage and which client is busy
-- matter more than the exact wording of what it's doing.

local M = {}

-- kept short on purpose: percentage and client name are the load-bearing
-- info, the operation title is a nice-to-have so it's capped hard
local MAX_TITLE_LEN = 20

-- keyed by "<client_id>:<token>" -> { client_id, title, percentage }
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
    M._entries[k] = { client_id = client_id }
  end
  local entry = M._entries[k]
  entry.title = value.title or entry.title
  entry.percentage = value.percentage
end

--- Drop everything tracked for a client - used on LspDetach so a client that
--- crashes mid-report doesn't leave a stale "54% ruby_lsp: indexing" forever.
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

--- Render current progress for the statusline, e.g. "40% ruby_lsp: indexing".
--- @return string
function M.render()
  local parts = {}
  for _, k in ipairs(M._order) do
    local entry = M._entries[k]
    local client = vim.lsp.get_client_by_id(entry.client_id)
    local piece = client and client.name or ("client " .. entry.client_id)
    if entry.percentage then
      piece = entry.percentage .. "% " .. piece
    end
    if entry.title then
      -- some servers prefix their own name into the title (e.g. ruby_lsp
      -- sends "Ruby LSP: indexing files"), which would duplicate the client
      -- name above, so keep only the part after the last colon
      local op = entry.title:match(":%s*(.-)%s*$") or entry.title
      if #op > MAX_TITLE_LEN then
        op = op:sub(1, MAX_TITLE_LEN - 1) .. "…"
      end
      piece = piece .. ": " .. op
    end
    table.insert(parts, piece)
  end
  return table.concat(parts, ", ")
end

--- Reset all tracked state (e.g. after editing this file to try a format change).
function M._reset()
  M._entries = {}
  M._order = {}
end

return M
