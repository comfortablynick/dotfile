scriptencoding utf-8

function plugins#webdevicons#post()
    " post() needed because we have to update variable defined by plugin
    let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols['todo.txt'] = '🗹'
endfunction
