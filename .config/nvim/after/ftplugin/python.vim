setlocal smartindent
setlocal autoindent
setlocal foldmethod=marker
setlocal formatprg=black\ -q\ -

let g:python_highlight_all=1
let $PYTHONUNBUFFERED=1

let g:semshi#mark_selected_nodes = 0
let g:semshi#error_sign = v:false
