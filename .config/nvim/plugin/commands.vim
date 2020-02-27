" ====================================================
" Filename:    plugin/commands.vim
" Description: General commands
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-27 16:18:08 CST
" ====================================================
if exists('g:loaded_plugin_commands') | finish | endif
let g:loaded_plugin_commands = 1

" Floating help window
command! -complete=help -nargs=? Help lua require'window'.floating_help(<q-args>)
command! -complete=help -nargs=? H Help <args>

" Float terminal
command! -complete=file -nargs=? FloatTerm lua require'window'.float_term(<q-args>, 50)

" Run a command asynchronously
command! -complete=file -bang -nargs=? Run lua require'tools'.async_run(<q-args>, '<bang>')
command! -complete=file -bang -nargs=? Cmd lua require'tools'.run(<q-args>)

" Pretty-printing
" Using Lua vim.inspect()
command! -complete=var -nargs=1 LPrint echo v:lua.vim.inspect(<args>)
" Using python pformat (handles lists better)
command! -complete=var -nargs=1 PPrint echo util#pformat(<args>)

" Save if file has changed and reload vimrc
command! S update | source $MYVIMRC
" Easily change background
command! Light set background=light
command! Dark  set background=dark
" Lua async grep
command! -nargs=+ -complete=dir -bar Grep
    \ lua require'tools'.async_grep(<q-args>)
" Delete buffer without changing window layout
command! -bang -complete=buffer -nargs=? Bclose
    \ packadd vim-bbye | Bdelete<bang> <args>

" Commonly mistyped commands
command! WQ wq
command! Wq wq
command! Wqa wqa
command! W w

" Lazy load startuptime.vim plugin
command! -nargs=* -complete=file StartupTime
    \ packadd startuptime.vim | StartupTime <args>

" Lazy load scriptease plugin
command! -bar Messages
    \ packadd vim-scriptease | Messages

" Usage:
" 	:Redir hi .........show the full output of command ':hi' in a scratch window
" 	:Redir !ls -al ....show the full output of command ':!ls -al' in a scratch window
command! -nargs=1 -complete=command Redir silent call util#redir(<q-args>)

" Display :scriptnames in quickfix and optionally filter
command! -nargs=* -bar -count=0 Scriptnames
    \ call quickfix#scriptnames(<f-args>) |
    \ copen |
    \ <count>
