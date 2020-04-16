let s:guard = 'g:loaded_autoload_plugins_asynctasks' | if exists(s:guard) | finish | endif
let {s:guard} = 1

function! plugins#asynctasks#post() abort
    let g:asynctasks_extra_config = [
        \ '~/.config/nvim/tasks.ini',
        \ ]
endfunction
