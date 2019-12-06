" ====================================================
" Filename:    plugin/deoplete.vim
" Description: Deoplete completion plugin config
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-12-06
" ====================================================
if exists('g:loaded_plugin_deoplete_jdh6forp') | finish | endif
let g:loaded_plugin_deoplete_jdh6forp = 1

augroup plugin_deoplete_jdh6forp
    autocmd!
    autocmd FileType *
        \ if exists('g:completion_filetypes') &&
        \ index(g:completion_filetypes['deoplete'], &filetype) >= 0
        \ | call config#deoplete#init()
        \ | endif
augroup END
