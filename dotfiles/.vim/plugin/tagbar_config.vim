if exists('g:loaded_tagbar_config')
    finish
endif
let g:loaded_tagbar_config = 1

let g:tagbar_autoclose = 1                                      " Autoclose tagbar after selecting tag
let g:tagbar_autofocus = 1                                      " Move focus to tagbar when opened
let g:tagbar_compact = 1                                        " Eliminate help msg, blank lines
let g:tagbar_autopreview = 0                                    " Open preview window with selected tag details
let g:tagbar_sort = 0                                           " Sort tags alphabetically vs. in file order
