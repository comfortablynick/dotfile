"
"   __   _ _ _ __ ___  _ __ ___
"   \ \ / / | '_ ` _ \| '__/ __|
"    \ V /| | | | | | | | | (__
"     \_/ |_|_| |_| |_|_|  \___|
"
"

" GLOBAL VIM / NEOVIM SETTINGS

" SHELL =========================================
" Vim apparently doesn't care for fish
" Load bash instead for Vim purposes
if $SHELL =~# 'bin/fish'
    set shell=/bin/sh
endif

" AUGROUP =======================================
" General augroup for vimrc files
" Add to this group freely throughout config
augroup vimrc
    autocmd!
augroup END

" CONFIG FILES ==================================
let g:vim_home = get(g:, 'vim_home', expand('~/.vim/config/'))

let config_list = [
    \ 'config.vim',
    \ 'plugins.vim',
    \ 'functions.vim',
    \ 'theme.vim',
    \ 'map.vim'
    \ ]

for files in config_list
    for f in glob(g:vim_home.files, 1, 1)
        exec 'source' f
    endfor
endfor
