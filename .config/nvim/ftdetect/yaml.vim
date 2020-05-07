" vint: -ProhibitAutocmdWithNoGroup

autocmd BufRead,BufNewFile .prettierrc call s:set_filetype()

function! s:set_filetype() abort
    if &filetype !=# 'yaml'
        set filetype=yaml
    endif
endfunction
