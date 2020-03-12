--- Neovim Helpers
--- Customized from: https://github.com/norcalli/nvim_utils/blob/master/lua/nvim_utils.lua
local vim = vim
local api = vim.api
nvim = {}
-- Buffer {{{1
function nvim.mark_or_index(buf, input) -- {{{2
    -- An enhanced version of nvim_buf_get_mark which also accepts:
    -- - A number as input: which is taken as a line number.
    -- - A pair, which is validated and passed through otherwise.
    if type(input) == "number" then
        -- TODO how to handle column? It would really depend on whether this was the opening mark or ending mark
        -- It also doesn't matter as long as the functions are respecting the mode for transformations
        assert(input ~= 0, "Line number must be >= 1 or <= -1 for last line(s)")
        return {input, 0}
    elseif type(input) == "table" then
        -- TODO Further validation?
        assert(#input == 2)
        assert(input[1] >= 1)
        return input
    elseif type(input) == "string" then
        return api.nvim_buf_get_mark(buf, input)
    end
    assert(false, ("nvim_mark_or_index: Invalid input buf=%q, input=%q"):format(
               buf, input))
end

local VISUAL_MODE = {
    line = "line", -- linewise
    block = "block", -- characterwise
    char = "char", -- blockwise-visual
}

function nvim.buf_get_region_lines(buf, mark_a, mark_b, mode) -- {{{2
    --- Return the lines of the selection, respecting selection modes.
    -- RETURNS: table
    mode = mode or VISUAL_MODE.char
    buf = buf or api.nvim_get_current_buf()
    -- TODO keep these? @refactor
    mark_a = mark_a or "<"
    mark_b = mark_b or ">"

    local start = nvim.mark_or_index(buf, mark_a)
    local finish = nvim.mark_or_index(buf, mark_b)
    local lines = api.nvim_buf_get_lines(buf, start[1] - 1, finish[1], false)

    if mode == VISUAL_MODE.line then return lines end

    if mode == VISUAL_MODE.char then
        -- Order is important. Truncate the end first, because these are not commutative
        if finish[2] ~= 2147483647 then
            lines[#lines] = lines[#lines]:sub(1, finish[2] + 1)
        end
        if start[2] ~= 0 then lines[1] = lines[1]:sub(start[2] + 1) end
        return lines
    end

    local firstcol = start[2] + 1
    local lastcol = finish[2]
    if lastcol == 2147483647 then
        lastcol = -1
    else
        lastcol = lastcol + 1
    end
    for i, line in ipairs(lines) do lines[i] = line:sub(firstcol, lastcol) end
    return lines
end

function nvim.buf_set_region_lines(buf, mark_a, mark_b, mode, lines) -- {{{2
    buf = buf or 0
    mark_a = mark_a or "<"
    mark_b = mark_b or ">"

    assert(mode == VISUAL_MODE.line, "Other modes aren't supported yet")

    local start = nvim.mark_or_index(buf, mark_a)
    local finish = nvim.mark_or_index(buf, mark_b)

    return api.nvim_buf_set_lines(buf, start[1] - 1, finish[1], false, lines)
end

function nvim.buf_transform_region_lines(buf, mark_a, mark_b, mode, fn) -- {{{2
    -- This is actually more efficient if what you're doing is modifying a region
    -- because it can save api calls.
    -- It's also the only way to do transformations that are correct with `char` mode
    -- since it has to have access to the initial values of the region lines.
    buf = buf or api.nvim_get_current_buf()
    -- TODO keep these? @refactor
    mark_a = mark_a or "<"
    mark_b = mark_b or ">"

    local start = nvim.mark_or_index(buf, mark_a)
    local finish = nvim.mark_or_index(buf, mark_b)

    assert(start and finish)

    -- TODO contemplate passing in a function instead of lines as is.
    -- local lines
    -- local function lazy_lines()
    -- 	if not lines then
    -- 		lines = api.nvim_buf_get_lines(buf, start[1] - 1, finish[1], false)
    -- 	end
    -- 	return lines
    -- end

    local lines = api.nvim_buf_get_lines(buf, start[1] - 1, finish[1], false)

    local result
    if mode == VISUAL_MODE.char then
        local prefix = ""
        local suffix = ""
        -- Order is important. Truncate the end first, because these are not commutative
        -- TODO file a bug report about this, it's probably supposed to be -1
        if finish[2] ~= 2147483647 then
            suffix = lines[#lines]:sub(finish[2] + 2)
            lines[#lines] = lines[#lines]:sub(1, finish[2] + 1)
        end
        if start[2] ~= 0 then
            prefix = lines[1]:sub(1, start[2])
            lines[1] = lines[1]:sub(start[2] + 1)
        end
        result = fn(lines, mode)

        -- If I take the result being nil as leaving it unmodified, then I can use it
        -- to skip the set part and reuse this just to get fed the input.
        if result == nil then return end

        -- Sane defaults, assume that they want to erase things if it is empty
        if #result == 0 then result = {""} end

        -- Order is important. Truncate the end first, because these are not commutative
        -- TODO file a bug report about this, it's probably supposed to be -1
        if finish[2] ~= 2147483647 then
            result[#result] = result[#result] .. suffix
        end
        if start[2] ~= 0 then result[1] = prefix .. result[1] end
    elseif mode == VISUAL_MODE.line then
        result = fn(lines, mode)
        -- If I take the result being nil as leaving it unmodified, then I can use it
        -- to skip the set part and reuse this just to get fed the input.
        if result == nil then return end
    elseif mode == VISUAL_MODE.block then
        local firstcol = start[2] + 1
        local lastcol = finish[2]
        if lastcol == 2147483647 then
            lastcol = -1
        else
            lastcol = lastcol + 1
        end
        local block = {}
        for _, line in ipairs(lines) do
            table.insert(block, line:sub(firstcol, lastcol))
        end
        result = fn(block, mode)
        -- If I take the result being nil as leaving it unmodified, then I can use it
        -- to skip the set part and reuse this just to get fed the input.
        if result == nil then return end

        if #result == 0 then result = {""} end
        for i, line in ipairs(lines) do
            local result_index = (i - 1) % #result + 1
            local replacement = result[result_index]
            lines[i] = table.concat{
                line:sub(1, firstcol - 1),
                replacement,
                line:sub(lastcol + 1),
            }
        end
        result = lines
    end

    return api.nvim_buf_set_lines(buf, start[1] - 1, finish[1], false, result)
end

function nvim.source_current_buffer() -- {{{2
    -- luacheck: ignore loadstring
    loadstring(table.concat(nvim.buf_get_region_lines(nil, 1, -1,
                                                      VISUAL_MODE.line), "\n"))()
end

-- Higher level text manipulation {{{1
function nvim.set_selection_lines(lines) -- {{{2
    return nvim.buf_set_region_lines(nil, "<", ">", VISUAL_MODE.line, lines)
end

function nvim.selection(mode) -- {{{2
    -- Return the selection as a string
    -- RETURNS: string
    local sel = nvim.buf_get_region_lines(nil, "<", ">",
                                          mode or VISUAL_MODE.char)
    return table.concat(sel, "\n")
end

-- function LuaExprCallBack() {{{2
-- VimL glue function for nvim_text_operator
-- Calls the lua function whose name is g:lua_fn_name and forwards its arguments
vim.cmd[[
function! LuaExprCallback(...) abort
	return luaeval(g:lua_expr, a:000)
endfunction
]]

function nvim.text_operator(fn) -- {{{2
    LUA_FUNCTION = fn
    vim.g.lua_expr = "LUA_FUNCTION(_A[1])"
    vim.o.opfunc = "LuaExprCallback"
    api.nvim_feedkeys("g@", "ni", false)
end

function nvim_text_operator_transform_selection(fn, forced_visual_mode) -- {{{2
    return nvim.text_operator(function(visualmode)
        nvim.buf_transform_region_lines(nil, "[", "]",
                                        forced_visual_mode or visualmode,
                                        function(lines)
            return fn(lines, visualmode)
        end)
    end)
end

function nvim.visual_mode() -- {{{2
    local visualmode = vim.fn.visualmode()
    if visualmode == "v" then
        return VISUAL_MODE.char
    elseif visualmode == "V" then
        return VISUAL_MODE.line
    else
        return VISUAL_MODE.block
    end
end

function nvim.transform_cword(fn) -- {{{2
    nvim_text_operator_transform_selection(
        function(lines) return {fn(lines[1])} end)
    api.nvim_feedkeys("iw", "ni", false)
end

function nvim.transform_cWORD(fn) -- {{{2
    nvim.text_operator_transform_selection(
        function(lines) return {fn(lines[1])} end)
    api.nvim_feedkeys("iW", "ni", false)
end

-- luacheck: compat
local LUA_BUFFER_MAPPING = {}
-- Mappings {{{1
local function escape_keymap(key) -- {{{2
    -- Prepend with a letter so it can be used as a dictionary key
    return "k" .. key:gsub(".", string.byte)
end

local valid_modes = {
    n = "n",
    v = "v",
    x = "x",
    i = "i",
    o = "o",
    t = "t",
    c = "c",
    s = "s",
    -- :map! and :map
    ["!"] = "!",
    [" "] = "",
}

function nvim.apply_mappings(mappings, default_options) -- {{{2
    -- TODO(ashkan) @feature Disable noremap if the rhs starts with <Plug>
    local LUA_MAPPING = {} -- luacheck: ignore
    -- May or may not be used.
    local current_bufnr = 0
    for key, options in pairs(mappings) do
        options = vim.tbl_extend("keep", options, default_options or {})
        local bufnr = current_bufnr
        if type(options.buffer) == "number" and options.buffer ~= 0 then
            bufnr = options.buffer
        end
        local mode, mapping = key:match("^(.)(.+)$")
        assert(mode,
               "nvim_apply_mappings: invalid mode specified for keymapping " ..
                   key)
        assert(valid_modes[mode],
               "nvim_apply_mappings: invalid mode specified for keymapping. mode=" ..
                   mode)
        mode = valid_modes[mode]
        local rhs = options[1]
        options[1] = nil
        if type(rhs) == "function" then
            -- Use a value that won't be misinterpreted below since special keys
            -- like <CR> can be in key, and escaping those isn't easy.
            local escaped = escape_keymap(key)
            local key_mapping
            if options.dot_repeat then
                local key_function = rhs
                rhs = function()
                    key_function()
                    vim.fn["repeat#set"](
                        api.nvim_replace_termcodes(key_mapping, true, true, true),
                        vim.v.count)
                end
                options.dot_repeat = nil
            end
            if options.buffer then
                -- Initialize and establish cleanup
                if not LUA_BUFFER_MAPPING[bufnr] then
                    LUA_BUFFER_MAPPING[bufnr] = {}
                    -- Clean up our resources.
                    api.nvim_buf_attach(bufnr, false, {
                        on_detach = function()
                            LUA_BUFFER_MAPPING[bufnr] = nil
                        end,
                    })
                end
                LUA_BUFFER_MAPPING[bufnr][escaped] = rhs
                if mode == "x" or mode == "v" then
                    key_mapping =
                        (":<C-u>lua LUA_BUFFER_MAPPING[%d].%s()<CR>"):format(
                            bufnr, escaped)
                else
                    key_mapping =
                        ("<Cmd>lua LUA_BUFFER_MAPPING[%d].%s()<CR>"):format(
                            bufnr, escaped)
                end
            else
                LUA_MAPPING[escaped] = rhs
                if mode == "x" or mode == "v" then
                    key_mapping = (":<C-u>lua LUA_MAPPING.%s()<CR>"):format(
                                      escaped)
                else
                    key_mapping = ("<Cmd>lua LUA_MAPPING.%s()<CR>"):format(
                                      escaped)
                end
            end
            rhs = key_mapping
            options.noremap = true
            options.silent = true
        end
        if options.buffer then
            options.buffer = nil
            api.nvim_buf_set_keymap(bufnr, mode, mapping, rhs, options)
        else
            api.nvim_set_keymap(mode, mapping, rhs, options)
        end
    end
end

function nvim.create_augroups(definitions) -- {{{2
    for group_name, definition in pairs(definitions) do
        api.nvim_command("augroup " .. group_name)
        api.nvim_command("autocmd!")
        for _, def in ipairs(definition) do
            -- if type(def) == 'table' and type(def[#def]) == 'function' then
            -- 	def[#def] = lua_callback(def[#def])
            -- end
            local command = table.concat(vim.tbl_flatten{"autocmd", def}, " ")
            api.nvim_command(command)
        end
        api.nvim_command("augroup END")
    end
end

function nvim.define_text_object(mapping, function_name) -- {{{2
    local options = {silent = true, noremap = true}
    api.nvim_set_keymap("n", mapping,
                        ("<Cmd>lua %s(%s)<CR>"):format(function_name, false),
                        options)
    api.nvim_set_keymap("x", mapping,
                        (":lua %s(%s)<CR>"):format(function_name, true), options)
end

function printf(msg, ...) -- {{{2
    -- C-style printf
    print(msg ~= nil and string.format(msg, ...) or nil)
end

function p(val, ...) -- {{{2
    -- Debug print helper
    -- If `val` is not a simple type, run it through inspect() first
    -- Else treat as printf
    local wrapper = function(s, ...)
        if type(val) == ("string" or "number") then
            print(string.format(s, ...))
        else
            print(vim.inspect(s))
        end
    end
    -- Just print if there's an error (bad format str, etc.)
    if not pcall(wrapper, val, ...) then print(val, ...) end
end

-- luacheck: ignore string
-- Strings {{{1
function string.startswith(s, n) -- {{{2
    return s:sub(1, #n) == n
end

function string.endswith(self, str) -- {{{2
    return self:sub(-(#str)) == str
end

function string.basename(str) -- {{{2
    local name = string.gsub(str, "(.*/)(.*)", "%2")
    return name
end

function string.trim(str, chars) -- {{{2
    local patternescape = function(s)
        return s:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
    end
    if not chars then return str:match("^[%s]*(.-)[%s]*$") end
    chars = patternescape(chars)
    return str:match("^[" .. chars .. "]*(.-)[" .. chars .. "]*$")
end

local HANDLES = {}
-- Spawn utils {{{1
local function clean_handles() -- {{{2
    local n = 1
    while n <= #HANDLES do
        if HANDLES[n]:is_closing() then
            table.remove(HANDLES, n)
        else
            n = n + 1
        end
    end
end

function nvim.spawn(cmd, params, onexit) -- {{{2
    local handle, pid
    handle, pid = vim.loop.spawn(cmd, params, function(code, signal)
        if type(onexit) == "function" then onexit(code, signal) end
        handle:close()
        clean_handles()
    end)
    table.insert(HANDLES, handle)
    return handle, pid
end

function nvim.timer_start(timeout, callback) -- {{{2
    local timer = vim.loop.new_timer()
    timer:start(timeout, 0, vim.schedule_wrap(function()
        timer:stop()
        timer:close()
        callback()
    end))
    return timer
end

-- Iterator utils {{{1
-- Helper functions {{{2
-- From: https://github.com/rxi/lume
local identity = function(x) return x end

local iteratee = function(x)
    if x == nil then return identity end
    if vim.is_callable(x) then return x end
    if type(x) == "table" then
        return function(z)
            for k, v in pairs(x) do
                if z[k] ~= v then return false end
            end
            return true
        end
    end
    return function(z) return z[x] end
end

local getiter = function(x)
    vim.validate{arg = {x, "table"}}
    if vim.tbl_islist(x) then
        return ipairs
    else
        return pairs
    end
end

-- nvim.filter :: calls `fn` on each value in table `t` {{{2
-- Returns new table where `fn` returned true.
function nvim.filter(t, fn, retainkeys)
    fn = iteratee(fn)
    local iter = getiter(t)
    local rtn = {}
    if retainkeys then
        for k, v in iter(t) do if fn(v) then rtn[k] = v end end
    else
        for _, v in iter(t) do if fn(v) then rtn[#rtn + 1] = v end end
    end
    return rtn
end

-- nvim.map :: applies `fn` to each value in table `t` {{{2
-- Returns a new table with the resulting values.
function nvim.map(t, fn)
    fn = iteratee(fn)
    local iter = getiter(t)
    local rtn = {}
    for k, v in iter(t) do rtn[k] = fn(v) end
    return rtn
end

-- nvim.reduce :: applies `fn` cumulatively to values in table `t` {{{2
-- Reduces array to a single value.
function nvim.reduce(t, fn, first)
    local started = first ~= nil
    local acc = first
    local iter = getiter(t)
    for _, v in iter(t) do
        if started then
            acc = fn(acc, v)
        else
            acc = v
            started = true
        end
    end
    assert(started, "reduce of an empty table with no first value")
    return acc
end

-- nvim.each :: calls `fn` on each value in table `t` {{{2
-- If `fn` is a string, it is called as a method.
-- Returns `t` unmodified.
function nvim.each(t, fn, ...)
    local iter = getiter(t)
    if type(fn) == "string" then
        for _, v in iter(t) do v[fn](v, ...) end
    else
        for _, v in iter(t) do fn(v, ...) end
    end
    return t
end

-- Return module {{{1
return nvim
-- vim:fdl=1: