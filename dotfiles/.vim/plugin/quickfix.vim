" ====================================================
" Filename:    plugin/quickfix.vim
" Description: Commands for quickfix window
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-11 14:08:34 CST
" ====================================================
if exists('g:loaded_plugin_quickfix')
    \ || exists('g:no_load_plugins')
    finish
endif
let g:loaded_plugin_quickfix = 1

" Defaults
let g:quickfix_size = 12

" Close qf after lint if empty
augroup plugin_quickfix
    autocmd!
    autocmd User ALELintPost call quickfix#close_empty()
    autocmd FileType qf wincmd J
augroup end

nnoremap <silent> <Leader>q :call quickfix#toggle()<CR>
