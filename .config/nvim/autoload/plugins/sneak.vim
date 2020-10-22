function! plugins#sneak#pre() abort
    let g:sneak#label = 1

    call s:add_sneak_highlights()
endfunction

function! s:add_sneak_highlights() abort
    hi Sneak ctermfg=red ctermbg=234 guifg=#ff0000 guibg=#1c1c1c
endfunction

augroup autoload_plugins_sneak
    autocmd!
    autocmd ColorScheme * call s:add_sneak_highlights()
augroup END
