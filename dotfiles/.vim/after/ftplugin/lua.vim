" ====================================================
" Filename:    after/ftplugin/lua.vim
" Description: Lua filetype overrides
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-22 21:22:35 CST
" ====================================================
if exists('g:loaded_after_ftplugin_lua_dzkzqoxu') | finish | endif
let g:loaded_after_ftplugin_lua_dzkzqoxu = 1

let g:lua_syntax_nofold = 1

" Override vim ftplugin and set not to add comment leader on new line
setlocal formatoptions-=o formatoptions-=r
setlocal formatprg=lua-format\ --config=$XDG_CONFIG_HOME/.lua-format

if exists(':Luadev')
    map lr   <Plug>(Luadev-Run)
    map lrl  <Plug>(Luadev-RunLine)
endif
