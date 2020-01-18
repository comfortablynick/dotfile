local a = vim.api
local exists = vim.fn.exists
local util = require "util"
local try = util.try
ll = {}

vim.g.LL_pl = vim.g.LL_pl or 0
vim.g.LL_nf = vim.g.LL_nf or 0

local WINWIDTH = vim.api.nvim_win_get_width(0)
local vars = {
    min_width = 90,
    med_width = 140,
    max_width = 200,
    use_simple_sep = vim.env.SUB ~= "|" and 0 or 1,
    use_pl_fonts = vim.g.LL_pl,
    use_nerd_fonts = vim.g.LL_nf,
    glyphs = {
        line_no = "",
        vcs = vim.g.LL_nf ~= 1 and "" or " ",
        branch = "",
        line = "☰",
        read_only = vim.g.LL_pl ~= 1 and "--RO-- " or " ",
        -- modified = " [+]",
        modified = " ●",
        func = "ƒ ",
        linter_checking = vim.g.LL_nf ~= 1 and "..." or "\u{f110}",
        linter_warnings = vim.g.LL_nf ~= 1 and "•" or "\u{f071}",
        linter_errors = vim.g.LL_nf ~= 1 and "•" or "\u{f05e}",
        linter_ok = "",
    },
}

-- List of plugins/non-files for special handling
local special_filetypes = {
    nerdtree = "NERD",
    netrw = "NETRW",
    defx = "DEFX",
    vista = "VISTA",
    tagbar = "TAGS",
    undotree = "UNDO",
    qf = "",
    ["coc-explorer"] = "EXPLORER",
    ["output=///info"] = "COC-INFO",
    vimfiler = "FILER",
    minpac = "PACK",
    packager = "PACK",
}

local function lightline_config() -- luacheck: ignore
    vim.g.lightline_test = {
        tabline = {left = {{"buffers"}}, right = {{"filesize"}}},
        active = {
            left = {
                {"vim_mode", "paste"},
                {"filename"},
                {
                    "git_status",
                    "linter_checking",
                    "linter_errors",
                    "linter_warnings",
                    "coc_status",
                },
            },
            right = {
                {"line_info"},
                {"filetype_icon", "fileencoding_non_utf", "fileformat_icon"},
                {"current_tag"},
                {"asyncrun_status"},
            },
        },
        inactive = {
            left = {{"filename"}},
            right = {
                {"line_info"},
                {"filetype_icon", "fileencoding_non_utf", "fileformat_icon"},
            },
        },
        component = {filename = "%<%{LL_FileName()}"},
        component_function = {
            git_status = "LL_GitStatus",
            filesize = "LL_FileSize",
            filetype_icon = "LL_FileType",
            fileformat_icon = "LL_FileFormat",
            fileencoding_non_utf = "LL_FileEncoding",
            line_info = "LL_LineInfo",
            vim_mode = "LL_Mode",
            venv = "LL_VirtualEnvName",
            current_tag = "LL_CurrentTag",
            coc_status = "LL_CocStatus",
            asyncrun_status = "LL_AsyncRunStatus",
        },
        tab_component_function = {filename = "LL_TabName"},
        component_expand = {
            linter_checking = "lightline#ale#checking",
            linter_warnings = "LL_LinterWarnings",
            linter_errors = "LL_LinterErrors",
            linter_ok = "lightline#ale#ok",
            buffers = "lightline#bufferline#buffers",
        },
        component_type = {
            readonly = "error",
            linter_checking = "left",
            linter_warnings = "warning",
            linter_errors = "error",
            linter_ok = "left",
            buffers = "tabsel",
            cocerror = "error",
            cocwarn = "warn",
        },
        separator = {left = "", right = ""},
        subseparator = {left = "|", right = "|"},
    }
    -- for name, value in pairs(vars) do
    --     vim.g[name] = value
    -- end
end

-- lightline_config()

function ll.is_not_file()
    -- local exclude = {
    --     "nerdtree",
    --     "netrw",
    --     "defx",
    --     "output",
    --     "vista",
    --     "undotree",
    --     "vimfiler",
    --     "tagbar",
    --     "minpac",
    --     "packager",
    --     "qf",
    --     "coc-explorer",
    --     "output:///info",
    -- }
    -- for _, v in ipairs(exclude) do
    --     if v == filetype or v == vim.fn.expand("%:t") or v == vim.fn.expand("%") then
    --         return true
    --     end
    -- end
    -- return false
    return special_filetypes[vim.bo.filetype] ~= nil
end

function ll.line_info()
    local line_ct = a.nvim_buf_line_count(0)
    local pos = a.nvim_win_get_cursor(0)
    local row = pos[1]
    local col = pos[2] + 1
    local row_pos = function()
        local max_digits = string.len(tostring(line_ct))
        return string.format(
                   "%" .. max_digits .. "d/%" .. max_digits .. "d", row, line_ct
               )
    end
    return string.format(
               "%3d%% %s %s %s :%3d", row * 100 / line_ct, vars.glyphs.line,
               row_pos(), vars.glyphs.line_no, col
           )
end

function ll.mode()
    local mode_map = {
        n = {"NORMAL", "NRM", "N"},
        i = {"INSERT", "INS", "I"},
        R = {"REPLACE", "REP", "R"},
        v = {"VISUAL", "VIS", "V"},
        V = {"V-LINE", "V-LN", "V-L"},
        ["<C-V>"] = {"V-BLOCK", "V-BL", "V-B"},
        c = {"COMMAND", "CMD", "C"},
        s = {"SELECT", "SEL", "S"},
        S = {"S-LINE", "S-LN", "S-L"},
        ["<C-s>"] = {"S-BLOCK", "S-BL", "S-B"},
        t = {"TERMINAL", "TERM", "T"},
    }
    local mode_key = a.nvim_get_mode().mode
    local mode = mode_map[mode_key]
    local winwidth = a.nvim_win_get_width(0)
    local mode_out = function()
        if winwidth > vars.med_width then return mode[1] end
        if winwidth > vars.min_width then return mode[2] end
        return mode[3]
    end
    -- TODO: is filename ever going to match special_filetypes?
    -- viml: return get(l:special_modes, &filetype, get(l:special_modes, @%, l:mode_out))
    return special_filetypes[vim.bo.filetype] or mode_out()
end

local function python_venv()
    return not vim.g.did_coc_loaded and
               (vim.bo.ft == "python" and nvim.basename(vim.env.VIRTUAL_ENV)) or
               ""
end

function ll.file_type()
    local ft_glyph = WINWIDTH > vars.med_width and
                         try(
                             function()
                return " " .. vim.fn.WebDevIconsGetFileTypeSymbol()
            end
                         ) or ""
    local venv = WINWIDTH > vars.med_width and python_venv() or ""
    return vim.bo.filetype .. ft_glyph .. venv
end

function ll.file_format()
    local ff = vim.bo.fileformat
    if ll.is_not_file() or ff == "unix" then return "" end
    local ff_glyph = WINWIDTH > vars.med_width and vim.g.LL_nf and
                         try(vim.fn.WebDevIconsGetFileFormatSymbol) or ""
    return ff .. " " .. ff_glyph
end

function ll.file_size()
    local size = vim.loop.fs_stat(a.nvim_buf_get_name(0)).size
    return size > 0 and util.humanize_bytes(size) or ""
end

function ll.git_summary()
    -- Look for git hunk summary in this order:
    -- 1. coc-git
    -- 2. gitgutter
    -- 3. signify
    local hunks = (function()
        if exists("b:coc_git_status") == 1 then
            return vim.trim(a.nvim_buf_get_var(0, "coc_git_status"))
        end
        return try(vim.fn.GitGutterGetHunkSummary) or
                   try(vim.fn["sy#repo#get_stats"]) or {0, 0, 0}
    end)()
    local added = hunks[1] ~= 0 and string.format("+%d ", hunks[1]) or ""
    local changed = hunks[2] ~= 0 and string.format("~%d ", hunks[2]) or ""
    local deleted = hunks[3] ~= 0 and string.format("-%d ", hunks[3]) or ""
    return added .. changed .. deleted
end

function ll.git_branch()
    if vim.fn.exists("g:coc_git_status") == 1 then
        return vim.g.coc_git_status
    end
    return try(
               function()
            return vars.glyphs.branch .. " " .. vim.fn["fugitive#head"]()
        end
           ) or ""
end

function ll.git_status()
    if not ll.is_not_file() and WINWIDTH > vars.min_width then
        local branch = ll.git_branch()
        local hunks = ll.git_summary()
        return branch ~= "" and string.format(
                   "%s%s%s", vars.glyphs.vcs, branch,
                   hunks ~= "" and " " .. hunks or ""
               ) or ""
    end
    return ""
end

-- local runs = 1000
-- require'util'.bench(runs, ll.git_status)
-- require'util'.bench(runs, vim.fn.LL_GitStatus)