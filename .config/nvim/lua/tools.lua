local vim = vim
local a = vim.api
local uv = vim.loop
local luajob = require"luajob"
local M = {}

function M.async_grep(term) -- {{{1
    if not term then
        a.nvim_err_writeln("async grep: Search term missing")
        return
    end
    local stdout = uv.new_pipe(false)
    local stderr = uv.new_pipe(false)
    local results = {}
    local onread = function(err, data)
        assert(not err, err)
        if not data then return end
        for _, item in ipairs(vim.split(data, "\n")) do
            if item ~= "" then table.insert(results, item) end
        end
    end
    local onexit = function(code, signal)
        p({code = code, signal = signal})
        stdout:close()
        stderr:close()
        handle:close()
        vim.fn
            .setqflist({}, "r", {title = "AsyncGrep Results", lines = results})
        local result_ct = #results
        if result_ct > 0 then
            vim.cmd("cwindow " .. math.min(result_ct, 10))
        else
            print"grep: no results found"
        end
    end
    local grepprg = vim.split(vim.o.grepprg, " ")
    handle = uv.spawn(table.remove(grepprg, 1), {
        args = {term, unpack(grepprg)},
        stdio = {stdout, stderr},
    }, vim.schedule_wrap(onexit))
    uv.read_start(stdout, onread)
    uv.read_start(stderr, onread)
end

-- GIT

-- TODO: figure out how to return stdout,stderr from these
-- in simplest way possible
function M.git_pull() -- {{{1
    local cmd = luajob:new({
        cmd = "git pull",
        on_stdout = function(err, data)
            if err then
                print("error:", err)
            elseif data then
                local lines = vim.split(data, "\n")
                print(lines[1])
                vim.g.cmd_stdout = lines
            end
        end,
        on_stderr = function(err, data)
            if err then
                print("error:", err)
            elseif data then
                local lines = vim.split(data, "\n")
                print(lines[1])
                vim.g.cmd_stderr = lines
            end
        end,
    })
    cmd:start()
end

function M.git_branch() -- {{{1
    local git_branch = luajob:new({
        cmd = "git branch",
        on_stdout = function(err, data)
            if err then
                print("error:", err)
            elseif data then
                lines = vim.split(data, "\n")
                for _, line in ipairs(lines) do
                    if line:find("*") then
                        vim.api
                            .nvim_set_var("git_branch", (line:gsub("\n", "")))
                    end
                end
            end
        end,
        on_exit = function(code, signal)
            print("job exited", vim.inspect(code), signal)
        end,
    })
    git_branch.start()
end

-- Test lower level vim apis
function M.scandir(path) -- {{{1
    local d = uv.fs_scandir(vim.fn.expand(path))
    local out = {}
    while true do
        local name, type = uv.fs_scandir_next(d)
        if not name then break end
        table.insert(out, {name, type})
    end
    print(vim.inspect(out))
end

function M.readdir(path) -- {{{1
    local handle = uv.fs_opendir(vim.fn.expand(path), nil, 10)
    local out = {}
    while true do
        local entry = uv.fs_readdir(handle)
        if not entry then break end
        -- use list_extend because readdir
        -- outputs table with each iteration
        vim.list_extend(out, entry)
    end
    print(vim.inspect(out))
    uv.fs_closedir(handle)
end

function M.set_executable(file) -- {{{1
    file = file or a.nvim_buf_get_name(0)
    local get_perm_str = function(dec_mode)
        local mode = string.format("%o", dec_mode)
        local perms = {
            [0] = "---", -- No access.
            [1] = "--x", -- Execute access.
            [2] = "-w-", -- Write access.
            [3] = "-wx", -- Write and execute access.
            [4] = "r--", -- Read access.
            [5] = "r-x", -- Read and execute access.
            [6] = "rw-", -- Read and write access.
            [7] = "rwx", -- Read, write and execute access.
        }
        local chars = {}
        for i = 4, #mode do
            table.insert(chars, perms[tonumber(mode:sub(i, i))])
        end
        return table.concat(chars)
    end
    local stat = uv.fs_stat(file)
    if stat == nil then
        a.nvim_err_writeln(string.format("File '%s' does not exist!", file))
        return
    end
    local orig_mode = stat.mode
    local orig_mode_oct = string.sub(string.format("%o", orig_mode), 4)
    nvim.spawn("chmod", {args = {"u+x", file}}, function()
        local new_mode = uv.fs_stat(file).mode
        local new_mode_oct = string.sub(string.format("%o", new_mode), 4)
        local new_mode_str = get_perm_str(new_mode)
        if orig_mode ~= new_mode then
            printf("Permissions changed: %s (%s) -> %s (%s)",
                   get_perm_str(orig_mode), orig_mode_oct, new_mode_str,
                   new_mode_oct)
        else
            printf("Permissions not changed: %s (%s)", new_mode_str,
                   new_mode_oct)
        end
    end)
end

function M.get_history() -- {{{1
    local hist_ct = vim.fn.histnr("cmd")
    local hist = {}
    for i = 1, hist_ct do
        table.insert(hist,
                     string.format("%" .. #tostring(hist_ct) .. "d, %s",
                                   hist_ct - i, vim.fn.histget("cmd", -i)))
    end
    return hist
end

function M.run(cmd) -- {{{1
    -- Test run command using libuv api
    local stdout = uv.new_pipe(false)
    local stderr = uv.new_pipe(false)
    local command = vim.split(cmd, " ")
    local results = {}
    local onread = function(err, data)
        assert(not err, err)
        if not data then return end
        for _, item in ipairs(vim.split(data, "\n")) do
            if item ~= "" then table.insert(results, item) end
        end
    end
    local onexit = function(code)
        stdout:close()
        stderr:close()
        handle:close()
        if code ~= 0 then
            vim.api.nvim_err_writeln(string.format(
                                         "Cmd '%s' failed with exit code: %d",
                                         cmd, code))
            vim.g.job_status = "Failed"
        else
            vim.g.job_status = "Success"
        end
        if #results > 0 then
            vim.fn.setqflist({}, "r",
                             {title = "Command: " .. cmd, lines = results})
            vim.cmd("copen " .. math.min(#results, 10))
        end
    end
    handle = uv.spawn(table.remove(command, 1),
                      {args = command, stdio = {stdout, stderr}},
                      vim.schedule_wrap(onexit))
    vim.g.job_status = "Running"
    uv.read_start(stdout, onread)
    uv.read_start(stderr, onread)
end

function M.async_run(cmd, bang) -- {{{1
    local results = {}
    local command = cmd
    local qf_size = vim.g.quickfix_size or 20
    local unlet_timer = "autocmd CursorMoved,CursorMovedI * ++once " ..
                            "call timer_start(5000, {-> execute('unlet g:job_status', '')})"
    local on_read = function(err, data)
        assert(not err, err)
        if not data then return end
        for _, line in ipairs(vim.split(data, "\n")) do
            if line then table.insert(results, line) end
        end
    end
    local asyncjob = luajob:new({
        cmd = command,
        on_stdout = on_read,
        on_stderr = on_read,
        on_exit = function(code)
            if code ~= 0 then
                vim.g.job_status = "Failed"
            else
                vim.g.job_status = "Success"
            end
            if #results > 0 then
                vim.fn.setqflist({}, "r",
                                 {title = "Command: " .. cmd, lines = results})
                if bang == "!" then
                    print(results[1])
                else
                    vim.cmd("copen " .. math.min(#results, qf_size))
                end
                vim.cmd(unlet_timer)
            end
            -- require"window".create_scratch(results)
        end,
        detach = false,
    })
    asyncjob.start()
    vim.g.job_status = "Running"
end

function M.lscolors() -- {{{1
    -- Test parse $LS_COLORS
    local lsc = {}
    for _, item in ipairs(vim.split(vim.env.LS_COLORS, ":")) do
        local pair = vim.split(item, "=")
        local attrs = {}
        attrs.seq = pair[2]
        attrs.fg_color = string.match(pair[2] or "", "38;5;([0-9]+)")
        attrs.bg_color = string.match(pair[2] or "", "48;5;([0-9]+)")
        -- local elems = vim.split(pair[2] or "", ";")
        -- if elems[1] == "38" then
        --     attrs.type = "fg"
        -- elseif elems[1] == "48" then
        --     attrs.type = "bg"
        -- end
        -- if elems[2] == "5" then attrs["color256"] = elems[3] end
        lsc[pair[1]] = attrs
    end
    -- return lsc
    return lsc
end
-- Return module --{{{1
return M
