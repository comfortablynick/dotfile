" Find next help tag
nnoremap <silent><buffer> zl
  \ :call search('<Bar>[^ <Bar>]\+<Bar>\<Bar>''[A-Za-z0-9_-]\{2,}''')<CR>

augroup after_ft_help
    autocmd!
    autocmd BufWinEnter <buffer> wincmd o
augroup END
