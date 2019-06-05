if exists('g:loaded_nerdtree_config_vim')
    finish
endif
let g:loaded_nerdtree_config_vim = 1

let NERDTreeHighlightCursorline = 1
let NERDTreeIgnore = [
    \ '\.pyc$',
    \ '^__pycache__$',
    \ '.vscode',
    \ ]
let NERDTreeShowHidden = 1
let NERDTreeQuitOnOpen = 1

function! s:nerd_tree() abort
    if !exists('NERDTree')
        packadd nerdtree
    endif
    exe 'NERDTreeToggle'
endfunction


" Maps
if get(g:, 'use_nerdtree', 0) == 1
    nnoremap <silent> <Leader>n :call <SID>nerd_tree()<CR>
endif
