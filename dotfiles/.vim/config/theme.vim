" VIM COLORS/THEMES

" Airline {{{
" Map colorscheme to airline theme
let g:airline_themes = {
    \ 'nord': 'nord',
    \ 'snow-dark': 'snow_dark',
    \ 'snow-light': 'snow_light',
    \ 'papercolor': 'papercolor',
    \ 'PaperColor': 'PaperColor',
    \ 'gruvbox': 'gruvbox',
    \ }
" }}}
" Lightline {{{
" Status bar definition {{{
scriptencoding
let g:lightline = {
    \ 'tabline': {
    \   'left': [[ 'buffers' ]],
    \   'right': [[ 'close' ]],
    \ },
    \ 'active': {
    \   'left':
    \     [
    \        [ 'vim_mode', 'paste' ],
    \        [ 'fugitive' ],
    \        [ 'filename' ],
    \     ],
    \   'right':
    \     [
    \        [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok', 'line_info' ],
    \        [ 'filetype_icon', 'fileencoding_non_utf', 'fileformat_icon' ],
    \     ]
    \ },
    \ 'inactive': {
    \      'left':
    \     [
    \        [ 'filename' ]
    \     ],
    \      'right':
    \     [
    \        [ 'line_info' ],
    \        [ 'filetype_icon', 'fileencoding_non_utf', 'fileformat_icon' ],
    \     ]
    \ },
    \ 'component_function': {
    \   'fugitive': 'LL_Fugitive',
    \   'filename': 'LL_FileName',
    \   'filetype_icon': 'LL_FileType',
    \   'fileformat_icon': 'LL_FileFormat',
    \   'fileencoding_non_utf': 'LL_FileEncoding',
    \   'line_info': 'LL_LineInfo',
    \   'vim_mode': 'LL_Mode',
    \   'venv': 'LL_VirtualEnvName',
    \ },
    \ 'component_expand': {
    \   'linter_checking': 'lightline#ale#checking',
    \   'linter_warnings': 'lightline#ale#warnings',
    \   'linter_errors': 'lightline#ale#errors',
    \   'linter_ok': 'lightline#ale#ok',
    \   'buffers' : 'lightline#bufferline#buffers',
    \ },
    \ 'component_type': {
    \   'readonly': 'error',
    \   'linter_checking': 'left',
    \   'linter_warnings': 'warning',
    \   'linter_errors': 'error',
    \   'linter_ok': 'left',
    \   'buffers': 'tabsel',
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' },
    \ }
" }}}
" Section definitions {{{
" ALE Indicators {{{
let g:lightline#ale#indicator_checking = g:LL_nf ? '\uf110' : '...'
let g:lightline#ale#indicator_warnings = g:LL_nf ? '\uf071 ' : '⧍'
let g:lightline#ale#indicator_errors = g:LL_nf ? '\uf05e ' : '✗'
let g:lightline#ale#indicator_ok = '' " g:LL_nf ? '\uf00c' : '✓'
" }}}
" Main sections {{{
" Section settings / glyphs {{{
let g:LL_MinWidth = 90                                          " Width for using some expanded sections
let g:LL_MedWidth = 100                                         " Secondary width for some sections
let g:LL_LineNoSymbol = g:LL_pl ? '' : '␤'                     " Use  for line no unless no PL fonts
let g:LL_GitSymbol = g:LL_nf ? ' ' : ''                        " Use git symbol unless no nerd fonts
let g:LL_Branch = g:LL_pl ? '' : ''                           " Use git branch NF symbol (is '🜉' ever needed?)
let g:LL_LineSymbol = g:LL_pl ? '☰ ' : '☰ '                     " Is 'Ξ' ever needed?
let g:LL_ROSymbol = g:LL_pl ? '' : '--RO--'                    " Read-only PL symbol
let g:lightline#bufferline#enable_devicons = 1                  " Show devicons in buffer name
let g:lightline#bufferline#unicode_symbols = 1                  " Show unicode instead of ascii for readonly and modified
" }}}
" Section separators {{{
let g:lightline.separator.left = g:LL_pl ? '' : ''
let g:lightline.separator.right = g:LL_pl ? '' : ''
let g:lightline.subseparator.left = g:LL_pl ? '' : '|'
let g:lightline.subseparator.right = g:LL_pl ? '' : '|'
" }}}
function! LL_Modified() abort " {{{
    return &filetype =~? 'help\|vimfiler' ? '' : &modified ? '[+]' : &modifiable ? '' : '-'
endfunction
" }}}
function! LL_Mode() abort " {{{
    " TODO: abbreviate mode if < MinWidth
    return LL_IsNerd() ? 'NERD' : lightline#mode()
endfunction
" }}}
function! LL_IsNotFile() abort " {{{
    " Return true if not treated as file
    let exclude = [
        \ 'gitcommit',
        \ 'NERD_tree',
        \ 'output',
        \ ]
    for item in exclude
        if &filetype =~? item || expand('%:t') =~ item
            return 1
            break
        else
            continue
        endif
    endfor
endfunction
" }}}
function! LL_LinePercent() abort " {{{
    return printf('%3d%%', line('.') * 100 / line('$'))
endfunction
" }}}
function! LL_LineNo() abort " {{{
    let totlines = line('$')
    let maxdigits = len(string(totlines))
    return printf('%*d/%*d',
        \ maxdigits,
        \ line('.'),
        \ maxdigits,
        \ totlines
        \ )
endfunction
" }}}
function! LL_ColNo() abort " {{{
    return printf('%3d', virtcol('.'))
endfunction
" }}}
function! LL_LineInfo() abort " {{{
    return LL_IsNotFile() ? '' :
        \ printf('%s %s %s %s :%s',
        \ LL_LinePercent(),
        \ g:LL_LineSymbol,
        \ LL_LineNo(),
        \ g:LL_LineNoSymbol,
        \ LL_ColNo()
        \ )
endfunction
" }}}
function! LL_FileType() abort " {{{
    let ftsymbol = g:LL_nf &&
        \ exists('*WebDevIconsGetFileTypeSymbol') ?
        \ ' '.WebDevIconsGetFileTypeSymbol() :
        \ ''
    let venv = &filetype ==? 'python' ?
        \ ' ('.LL_VirtualEnvName().')' :
        \ ''
    return winwidth(0) > g:LL_MinWidth ? (&filetype . ftsymbol .venv ) : ''
endfunction
" }}}
function! LL_FileFormat() abort " {{{
    let ffsymbol = g:LL_nf &&
        \ exists('*WebDevIconsGetFileFormatSymbol') ?
        \ WebDevIconsGetFileFormatSymbol() :
        \ ''
    return LL_IsNotFile() ? '' : winwidth(0) > g:LL_MedWidth ? (&fileformat . ' ' . ffsymbol ) : ''
endfunction
" }}}
function! LL_FileEncoding() abort " {{{
    " Only return a value if != utf-8
    return &fileencoding !=? 'utf-8' ? &fileencoding : ''
endfunction
" }}}
function! LL_HunkSummary() abort " {{{
    let githunks = GitGutterGetHunkSummary()
    return printf('+%d ~%d -%d',
        \ githunks[0],
        \ githunks[1],
        \ githunks[2]
        \ )
endfunction
" }}}
function! LL_ReadOnly() abort " {{{
    return &filetype !~? 'help' && &readonly ? g:LL_ROSymbol : ''
endfunction
" }}}
function! LL_IsNerd() abort " {{{
    return expand('%:t') =~? 'NERD_tree'
endfunction
" }}}
function! LL_FileName() abort " {{{
    let fname = expand('%:t')
    return fname ==? 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
        \ fname ==? '__Tagbar__' ? g:lightline.fname :
        \ fname =~? '__Gundo\|NERD_tree' ? '' :
        \ &filetype ==? 'vimfiler' ? vimfiler#get_status_string() :
        \ &filetype ==? 'unite' ? unite#get_status_string() :
        \ &filetype ==? 'vimshell' ? vimshell#get_status_string() :
        \ ('' !=? LL_ReadOnly() ? LL_ReadOnly() . ' ' : '') .
        \ ('' !=? fname ? fname : '[No Name]') .
        \ ('' !=? LL_Modified() ? ' ' . LL_Modified() : '')
endfunction
" }}}
function! LL_Fugitive() abort " {{{
    if &filetype !~? 'vimfiler' && ! LL_IsNotFile() && exists('*fugitive#head') && winwidth(0) > g:LL_MinWidth
        let branch = fugitive#head()
        return branch !=# '' ? printf('%s%s %s %s',
            \ g:LL_GitSymbol,
            \ LL_HunkSummary(),
            \ g:LL_Branch,
            \ branch,
            \ ) : ''
    endif
    return ''
endfunction
" }}}
function! LL_VirtualEnvName() abort " {{{
    return !empty($VIRTUAL_ENV) ? split($VIRTUAL_ENV, '/')[-1] : ''
endfunction
" }}}
" }}}
" }}}
" }}}
" Vim / Neovim Settings {{{
" Set colors based on theme {{{
" vim_baseColor: 'nord-dark' -> 'nord'
let vim_baseColor = substitute(vim_color, '-dark\|-light', '', '')

" vim_variant: 'nord-dark' -> 'dark'
let vim_variant = substitute(vim_color, vim_baseColor . '-', '', '')

" Assign to variables
exe 'colorscheme '.vim_baseColor
exe 'set background='.vim_variant

" Set airline theme
let g:airline_theme = get(airline_themes, vim_color, vim_baseColor)

" Set lightline theme
let lightline['colorscheme'] = airline_theme
" }}}
" }}}
