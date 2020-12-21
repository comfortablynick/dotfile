function FormatExpr(start, end)
    silent execute a:start.','.a:end.'s/[.!?]\zs /\r/g'
endfunction

set formatexpr=FormatExpr(v:lnum,v:lnum+v:count-1)

" TODO: make outline prettier
function s:toc()
    let l:toc = []
    let l:buf = bufnr('')
    let l:lines = filter(map(getbufline(l:buf, 1, '$'), {k,v->[k+1, v]}), {_,v->v[1] =~# '^=\+'})
    for [l:ln, l:text] in l:lines
        call add(l:toc, #{bufnr: l:buf, lnum: l:ln, text: l:text})
    endfor
    call setloclist(0, l:toc, ' ')
    call setloclist(0, [], 'a', #{title: 'TOC'})
endfunction

nnoremap <buffer> gO <Cmd>call <SID>toc()\|call quickfix#loc_toggle(0)<CR>