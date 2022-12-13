local api = vim.api

-- Global functions
-- p :: Debug print helper
-- Now use built-in vim.pretty_print
_G.p = vim.pretty_print

-- function _G.p(...)
--   local valid, input_type = pcall(type, ...)
--   -- Handle blank/invalid input without error
--   if not valid then
--     return
--   end
--   if input_type == ("string" or "number") then
--     print(...)
--   else
--     local objects = {}
--     local v
--     for i = 1, select("#", ...) do
--       v = select(i, ...)
--       table.insert(objects, vim.inspect(v))
--     end
--
--     print(table.concat(objects, "\n"))
--     return ...
--   end
-- end

-- d :: Debug object using nvim-notify
function _G.d(...)
  local info = debug.getinfo(2, "S")
  local source = info.source:sub(2)
  source = vim.loop.fs_realpath(source) or source
  source = vim.fn.fnamemodify(source, ":~:.") .. ":" .. info.linedefined
  local what = { ... }
  if vim.tbl_islist(what) and vim.tbl_count(what) <= 1 then
    what = what[1]
  end
  local msg = vim.inspect(vim.deepcopy(what))
  vim.notify(msg, vim.log.levels.INFO, {
    title = "Debug: " .. source,
    on_open = function(win)
      vim.wo[win].conceallevel = 3
      vim.wo[win].concealcursor = ""
      vim.wo[win].spell = false
      local buf = vim.api.nvim_win_get_buf(win)
      vim.treesitter.start(buf, "lua")
    end,
  })
end

-- Smart [S-]Tab
local t = function(str)
  return api.nvim_replace_termcodes(str, true, true, true)
end

-- TODO: possibly include markdown tab logic
local check_back_space = function()
  local col = api.nvim_win_get_cursor(0)[2]
  return col == 0 or api.nvim_get_current_line():sub(col, col):match "%s" ~= nil
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.smart_tab = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
    -- TODO: why doesn't this work?
  elseif vim.F.npcall(vim.fn["Ultisnips#CanJumpForwards"]) == 1 then
    --   return t "<Plug>(UltiForward)"
    return vim.fn["UltiSnips#JumpForwards"]()
  elseif require("luasnip").expand_or_jumpable() then
    return t "<Plug>luasnip-expand-or-jump"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn["compe#complete"]()
  end
end

_G.smart_s_tab = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif require("luasnip").jumpable(-1) then
    return t "<Plug>luasnip-jump-prev"
  else
    return t "<S-Tab>"
  end
end

-- String indexing metamethods
-- Example:
-- a='abcdef'
-- return a[4]       --> d
-- return a(3,5)     --> cde
-- return a{1,-4,5}  --> ace
getmetatable("").__index = function(str, i)
  if type(i) == "number" then
    return string.sub(str, i, i)
  else
    return string[i]
  end
end

getmetatable("").__call = function(str, i, j)
  if type(i) ~= "table" then
    return string.sub(str, i, j)
  else
    local tbl = {}
    for k, v in ipairs(i) do
      tbl[k] = string.sub(str, v, v)
    end
    return table.concat(tbl)
  end
end
