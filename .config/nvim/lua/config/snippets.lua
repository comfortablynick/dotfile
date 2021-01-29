local snippets = vim.F.npcall(require, "snippets")
if not snippets then return nil end

local U = require"snippets.utils"
local indent = U.match_indentation
local comment = U.force_comment
local format = string.format
local snips = {}

snips._global = { -- {{{1
  -- If you aren't inside of a comment, make the line a comment.
  copyright = comment[[© Nicholas Murphy ${=os.date("%Y")}]],
  date = [[${=os.date("%F")}]],
}

snips.fish = { --{{{1
  int = [[if not status is-interactive
    exit
end]],
  sta = [[if status is-interactive
    $0
end]],
}

snips.lua = { -- {{{1
  req = [[local ${2:${1|S.v:match"([^.()]+)[()]*$"}} = require '$1']],
  func = [[function${1|vim.trim(S.v):gsub("^%S"," %0")}(${2|vim.trim(S.v)})$0 end]],
  ["local"] = [[local ${2:${1|S.v:match"([^.()]+)[()]*$"}} = ${1}]],
  -- Match the indentation of the current line for newlines.
  ["for"] = indent[[
for ${1:i}, ${2:v} in ipairs(${3:t}) do
  $0
end]],
}

snips.vim = { -- {{{1
  augroup = [[augroup ${=nvim.relative_name()}
    autocmd!
    autocmd $0
augroup END]],
  func = indent[[function ${1|vim.trim(S.v)}($2)
    $0
endfunction]],
  clap = comment([[Author: Nick Murphy <comfortablynick@gmail.com>
Description: $0]]),
  -- Do string formatting so function name shows upon snippet insertion using default inserter
  fua = indent(format([[function %s#${1|vim.trim(S.v)}($2)
    $0
endfunction]], nvim.relative_name():gsub("autoload_", ""):gsub("_", "#"))),
  ftdetect = [[" vint: -ProhibitAutocmdWithNoGroup
autocmd BufRead,BufNewFile $1 setfiletype $2]],
  ftdetect_verbose = [[" vint: -ProhibitAutocmdWithNoGroup
autocmd BufRead,BufNewFile $1 call s:set_filetype()

function s:set_filetype()
    if &filetype !=# '$2'
        set filetype=$2
    endif
endfunction]],
  modeline = comment[[vim:fdl=${=tostring(vim.wo.fdl)}:]],
  scriptguard = [[let s:guard = 'g:loaded_${=nvim.relative_name()}' | if exists(s:guard) | finish | endif
let {s:guard} = 1]],
}

snips.toml = { -- {{{1
  abbr = indent[=[[[abbr]]
key = '$1'
val = '$2'
cat = '$3'
desc = '$4'
shell = ['bash', 'zsh', 'fish']
]=],
  env = indent[=[[[env]]
key = '$1'
val = '$2'
cat = '$3'
desc = '$4'
shell = ['bash', 'zsh', 'fish']
]=],
}

-- setup {{{1
snippets.snippets = snips
snippets.use_suggested_mappings(true)
