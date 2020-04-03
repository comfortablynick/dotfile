" ====================================================
" Filename:    plugin/quickfix.vim
" Description: Quickfix/location list related config
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-04-03 16:17:03 CDT
" ====================================================
let s:guard = 'g:loaded_plugin_quickfix' | if exists(s:guard) | finish | endif
let {s:guard} = 1

" Defaults
let g:quickfix_size = 20

" Close qf after lint if empty
" augroup plugin_quickfix
"     autocmd!
"     autocmd FileType qf wincmd J
" augroup end

" Toggle quickfix
nnoremap <silent> Q :call quickfix#toggle()<CR>
