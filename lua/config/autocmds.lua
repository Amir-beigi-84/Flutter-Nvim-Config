-- Autocmds are automatically loaded on the VeryLazy event.

-- ──────────────────────────────────────────────────────────────────────────────
-- UI: close DAP float with 'q' and keep it out of :ls
-- ──────────────────────────────────────────────────────────────────────────────
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "dap-float" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set(
      "n",
      "q",
      "<cmd>close<cr>",
      { buffer = event.buf, silent = true }
    )
  end,
})

-- ──────────────────────────────────────────────────────────────────────────────
-- Dart LSP helpers
-- ──────────────────────────────────────────────────────────────────────────────

local function dartls_client()
  local list = vim.lsp.get_clients({ bufnr = 0, name = "dartls" })
  return list and list[1] or nil
end

local function offset_encoding()
  local c = dartls_client()
  return (c and c.offset_encoding) or "utf-16"
end

local function has_parse_errors()
  local errs =
    vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  return #errs > 0
end

-- Build a proper CodeActionParams with types the LS understands
local function make_code_action_params(only_list)
  ---@type lsp.CodeActionParams
  local params = vim.lsp.util.make_range_params(0, offset_encoding())
  params.context = { only = only_list, diagnostics = {} }
  return params
end

local function request_code_actions_sync(only_list, timeout_ms)
  local params = make_code_action_params(only_list)
  return vim.lsp.buf_request_sync(
    0,
    "textDocument/codeAction",
    params,
    timeout_ms or 1200
  )
end

local function apply_code_action(action)
  if not action then
    return false
  end
  local applied = false
  if action.edit then
    pcall(vim.lsp.util.apply_workspace_edit, action.edit, offset_encoding())
    applied = true
  end
  if action.command then
    pcall(vim.lsp.buf.execute_command, action.command)
    applied = true
  end
  return applied
end

local function apply_actions(results)
  if not results then
    return false
  end
  local any = false
  for _, res in pairs(results) do
    for _, action in ipairs(res.result or {}) do
      if apply_code_action(action) then
        any = true
      end
    end
  end
  return any
end

local function organize_imports_if_clean()
  if not dartls_client() or has_parse_errors() then
    return false
  end
  local results = request_code_actions_sync({ "source.organizeImports" }, 1200)
  return apply_actions(results)
end

local function fix_all_sync()
  if not dartls_client() then
    return false
  end
  local results = request_code_actions_sync({ "source.fixAll" }, 1500)
  local applied = apply_actions(results)
  if applied then
    return true
  end

  -- Fallback: look for explicit dart.edit.fixAll
  ---@type lsp.CodeActionParams
  local any_params = vim.lsp.util.make_range_params(0, offset_encoding())
  any_params.context = { diagnostics = {} }
  local all =
    vim.lsp.buf_request_sync(0, "textDocument/codeAction", any_params, 1500)
  if all then
    for _, res in pairs(all) do
      for _, action in ipairs(res.result or {}) do
        local cmd = action.command and action.command.command or nil
        if cmd == "dart.edit.fixAll" then
          if apply_code_action(action) then
            return true
          end
        end
      end
    end
  end
  return false
end

-- ──────────────────────────────────────────────────────────────────────────────
-- Hoist stray imports/exports to top so organize-imports won’t fail
-- ──────────────────────────────────────────────────────────────────────────────
local function dart_hoist_imports()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  if #lines == 0 then
    return
  end

  local keep, moved, seen = {}, {}, {}
  local function starts(s, pat)
    return s:match("^%s*" .. pat) ~= nil
  end
  local function is_directive(s)
    return starts(s, "import%s+") or starts(s, "export%s+")
  end

  for _, s in ipairs(lines) do
    if is_directive(s) then
      local trimmed = s:gsub("%s+$", "")
      if not seen[trimmed] then
        table.insert(moved, trimmed)
        seen[trimmed] = true
      end
    else
      table.insert(keep, s)
    end
  end
  if #moved == 0 then
    return
  end

  -- insertion point after optional comments/blank + optional library/part of
  local i = 1
  while keep[i] and (starts(keep[i], "//") or keep[i]:match("^%s*$")) do
    i = i + 1
  end
  if
    keep[i]
    and (starts(keep[i], "library%s+") or starts(keep[i], "part%s+of%s+"))
  then
    i = i + 1
    while keep[i] and keep[i]:match("^%s*$") do
      i = i + 1
    end
  end

  local new = {}
  for j = 1, i - 1 do
    new[#new + 1] = keep[j]
  end
  for _, s in ipairs(moved) do
    new[#new + 1] = s
  end
  new[#new + 1] = ""
  for j = i, #keep do
    new[#new + 1] = keep[j]
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new)
end

-- ──────────────────────────────────────────────────────────────────────────────
-- Dart on-save pipeline: Hoist → Organize Imports → Fix All → Format
-- ──────────────────────────────────────────────────────────────────────────────
local dart_group =
  vim.api.nvim_create_augroup("LspDartOnSave", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = dart_group,
  pattern = "*.dart",
  callback = function()
    pcall(dart_hoist_imports)

    local ok_oi, err_oi = pcall(organize_imports_if_clean)
    if not ok_oi and err_oi then
      vim.notify(
        "Organize Imports error: " .. tostring(err_oi),
        vim.log.levels.WARN
      )
    end

    local ok_fix, err_fix = pcall(fix_all_sync)
    if not ok_fix and err_fix then
      vim.notify("Fix All error: " .. tostring(err_fix), vim.log.levels.WARN)
    end

    local client = dartls_client()
    local ok_fmt, err_fmt = pcall(vim.lsp.buf.format, {
      async = false,
      timeout_ms = 1500,
      id = client and client.id or nil,
    })
    if not ok_fmt and err_fmt then
      vim.notify("Format error: " .. tostring(err_fmt), vim.log.levels.WARN)
    end
  end,
})
