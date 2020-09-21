let s:guard = 'g:loaded_autoload_floaterm_wrapper_fzy' | if exists(s:guard) | finish | endif
let {s:guard} = 1

function! floaterm#wrapper#fzy#(...) abort
    let s:fzy_temp = tempname()
    let l:cmd = 'fd -t f -HL | fzy -l 30 -p "'
    let l:cmd .= g:floaterm_open_command.'> " > '.s:fzy_temp
    return [l:cmd, {'on_exit': funcref('s:fzy_callback')}, v:false]
endfunction

function! s:fzy_callback(...) abort
    if filereadable(s:fzy_temp)
        let l:filename = readfile(s:fzy_temp)[0]
        if !empty(l:filename)
            execute g:floaterm_open_command fnameescape(l:filename)
        endif
    endif
endfunction