scriptencoding utf-8

" Variables {{{
let g:default_statusline = '%<%f %h%m%r'
let g:nf = !$MOSH_CONNECTION
let g:sl  = {
    \ 'width': {
    \     'min': 90,
    \     'med': 140,
    \     'max': 200,
    \ },
    \ 'sep': '┊',
    \ 'symbol': {
    \     'buffer': '❖',
    \     'branch': '',
    \     'git': '',
    \     'line_no': '',
    \     'lines': '☰',
    \     'modified': '●',
    \     'unmodifiable': '-',
    \     'readonly': '',
    \     'warning_sign' : '•',
    \     'error_sign'   : '✘',
    \     'success_sign' : '✓',
    \ },
    \ 'ignore': [
    \     'pine',
    \     'vfinder',
    \     'qf',
    \     'undotree',
    \     'diff',
    \     'coc-explorer',
    \ ],
    \ 'apply': {},
    \ 'colors': {
    \     'background'      : ['#2f343f', 'none'],
    \     'backgroundDark'  : ['#191d27', '16'],
    \     'backgroundLight' : ['#464b5b', '59'],
    \     'green'           : ['#2acf2a', '40'],
    \     'orange'          : ['#ff8700', 'none'],
    \     'main'            : ['#5295e2', '68'],
    \     'red'             : ['#f01d22', '160'],
    \     'text'            : ['#cbcbcb', '251'],
    \     'textDark'        : ['#8c8c8c', '244'],
    \ },
    \ }

" }}}

" Set statusline
set statusline=%!statusline#get(winnr())

" SL :: toggle statusline items
command! -nargs=? -complete=custom,statusline#complete_args SL
    \ call statusline#command(<f-args>)

" The following lines must come after colorscheme declaration
" Remove bold from StatusLine
function! s:set_user_highlights()
    call syntax#derive('StatusLine', 'StatusLine', 'cterm=reverse', 'gui=reverse')
    call syntax#derive('IncSearch', 'User1')
    call syntax#derive('WildMenu', 'User2', 'cterm=NONE', 'gui=NONE')
    call syntax#derive('Visual', 'User3')
    " call syntax#derive('StatusLine', 'User4', 'ctermbg=9', 'guibg=#af005f', 'cterm=reverse', 'gui=reverse')
    highlight link User4 ErrorMsg
    highlight link User5 Question
endfunction

call s:set_user_highlights()

augroup plugin_statusline
    autocmd!
    autocmd ColorScheme * call s:set_user_highlights()
augroup END
