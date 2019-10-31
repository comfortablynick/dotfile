" vim:fdl=1
" Config for lightline.vim status line
scriptencoding utf-8

if exists('g:loaded_lightline_vim_config')
    finish
endif
let g:loaded_lightline_vim_config = 1

" Definitions {{{1
" Status bar definition {{{2
let g:lightline = {
    \ 'tabline': {
    \   'left':
    \   [
    \       [ 'buffers' ],
    \   ],
    \   'right':
    \   [
    \       [ 'filename', 'filesize' ],
    \   ],
    \ },
    \ 'active': {
    \   'left':
    \    [
    \       [ 'vim_mode', 'paste' ],
    \       [ 'filename_short' ],
    \       [ 'git_status', 'coc_status'],
    \    ],
    \   'right':
    \    [
    \       [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok', 'line_info' ],
    \       [ 'filetype_icon', 'fileencoding_non_utf', 'fileformat_icon' ],
    \       [ 'current_tag' ],
    \    ]
    \ },
    \ 'inactive': {
    \      'left':
    \       [
    \           [ 'filename' ]
    \       ],
    \      'right':
    \       [
    \           [ 'line_info' ],
    \           [ 'filetype_icon', 'fileencoding_non_utf', 'fileformat_icon' ],
    \       ]
    \ },
    \ 'component_function': {
    \   'git_status': 'LL_GitStatus',
    \   'filename': 'LL_FileName',
    \   'filename_short': 'LL_FileNameShort',
    \   'filesize': 'LL_FileSize',
    \   'filetype_icon': 'LL_FileType',
    \   'fileformat_icon': 'LL_FileFormat',
    \   'fileencoding_non_utf': 'LL_FileEncoding',
    \   'line_info': 'LL_LineInfo',
    \   'vim_mode': 'LL_Mode',
    \   'venv': 'LL_VirtualEnvName',
    \   'current_tag': 'LL_CurrentTag',
    \   'coc_status': 'LL_CocStatus',
    \ },
    \ 'tab_component_function': {
    \   'filename': 'LL_TabName',
    \ },
    \ 'component_expand': {
    \   'linter_checking': 'lightline#ale#checking',
    \   'linter_warnings': 'LL_LinterWarnings',
    \   'linter_errors': 'LL_LinterErrors',
    \   'linter_ok': 'lightline#ale#ok',
    \   'buffers' : 'lightline#bufferline#buffers',
    \   'cocerror': 'LL_CocError',
    \   'cocwarn': 'LL_CocWarn',
    \ },
    \ 'component_type': {
    \   'readonly': 'error',
    \   'linter_checking': 'left',
    \   'linter_warnings': 'warning',
    \   'linter_errors': 'error',
    \   'linter_ok': 'left',
    \   'buffers': 'tabsel',
    \   'cocerror': 'error',
    \   'cocwarn': 'warn',
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '|', 'right': '|' },
    \ }

" Section settings / glyphs {{{2
let g:LL_MinWidth = 90                                          " Width for using some expanded sections
let g:LL_MedWidth = 140                                         " Secondary width for some sections
let g:LL_LineNoSymbol = ''                                     " Use  for line no unless no PL fonts; alt: '␤'
let g:LL_GitSymbol = g:LL_nf ? ' ' : ''                        " Use git symbol unless no nerd fonts
let g:LL_BranchSymbol = ' '                                    " Git branch symbol
let g:LL_LineSymbol = '☰ '                                      " Is 'Ξ' ever needed?
let g:LL_ROSymbol = g:LL_pl ? ' ' : '--RO-- '                  " Read-only symbol
let g:LL_ModSymbol = ' [+]'                                     " File modified symbol
let g:LL_SimpleSep = $SUB ==# '|' ? 1 : 0                       " Use simple section separators instead of PL (no other effects)
let g:LL_FnSymbol = 'ƒ '                                        " Use for current function

" Linter indicators
let g:LL_LinterChecking = g:LL_nf ? "\uf110 " : '...'
let g:LL_LinterWarnings = g:LL_nf ? "\uf071 " : '⧍'
let g:LL_LinterErrors = g:LL_nf ? "\uf05e " : '✗'
let g:LL_LinterOK = ''

" lightline#bufferline {{{2
let g:lightline#bufferline#enable_devicons = 1                  " Show devicons in buffer name
let g:lightline#bufferline#unicode_symbols = 1                  " Show unicode instead of ascii for readonly and modified
let g:lightline#bufferline#show_number  = 1
let g:lightline#bufferline#shorten_path = 1
let g:lightline#bufferline#unnamed      = '[No Name]'
" let g:lightline#bufferline#number_map = {
"     \ 0: '➓ ',
"     \ 1: '❶ ',
"     \ 2: '❷ ',
"     \ 3: '❸ ',
"     \ 4: '❹ ',
"     \ 5: '❺ ',
"     \ 6: '❻ ',
"     \ 7: '❼ ',
"     \ 8: '❽ ',
"     \ 9: '❾ ',
"     \ }

nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)

" lightline#ale {{{2
let g:lightline#ale#indicator_checking = g:LL_LinterChecking
let g:lightline#ale#indicator_warnings = g:LL_LinterWarnings
let g:lightline#ale#indicator_errors = g:LL_LinterErrors
let g:lightline#ale#indicator_ok = g:LL_LinterOK

" coc#status {{{2
if exists('*lightline#update')
    autocmd vimrc User CocDiagnosticChange call lightline#update()
endif

" Section separators {{{2
" Get separators based on settings above "{{{
function! LL_Separator(side) abort "{{{
    if !g:LL_pl || g:LL_SimpleSep
        return ''
    elseif a:side ==? 'left'
        return ''
    elseif a:side ==? 'right'
        return ''
    else
        return ''
    end
endfunction
"}}}

function! LL_Subseparator(side) abort "{{{
    if !g:LL_pl || g:LL_SimpleSep
        return '|'
    elseif a:side ==? 'left'
        return ''
    elseif a:side ==? 'right'
        return ''
    else
        return ''
    endif
endfunction
"}}}
"}}}
let g:lightline.separator.left = LL_Separator('left')
let g:lightline.separator.right = LL_Separator('right')
let g:lightline.subseparator.left = LL_Subseparator('left')
let g:lightline.subseparator.right = LL_Subseparator('right')

" Component functions {{{1
function! LL_Modified() abort "{{{2
    return &filetype =~? 'help\|vimfiler' ? '' : &modified ? g:LL_ModSymbol : &modifiable ? '' : '-'
endfunction
function! LL_Mode() abort "{{{2
    " l:mode_map (0 = full size, 1 = medium abbr, 2 = short abbr)
    let l:mode_map = {
        \ 'n' :     ['NORMAL','NRM','N'],
        \ 'i' :     ['INSERT','INS','I'],
        \ 'R' :     ['REPLACE','REP','R'],
        \ 'v' :     ['VISUAL','VIS','V'],
        \ 'V' :     ['V-LINE','V-LN','V-L'],
        \ '\<C-v>': ['V-BLOCK','V-BL','V-B'],
        \ 'c' :     ['COMMAND','CMD','C'],
        \ 's' :     ['SELECT','SEL','S'],
        \ 'S' :     ['S-LINE','S-LN','S-L'],
        \ '\<C-s>': ['S-BLOCK','S-BL','S-B'],
        \ 't':      ['TERMINAL','TERM','T'],
        \ }
    let l:mode = mode()
    let f = @%
    if LL_IsNerd()
        return 'NERD'
    elseif f =~? '__Tagbar__'
        return 'TAGS'
    elseif f =~? 'undotree'
        return 'UNDO'
    elseif winwidth(0) > g:LL_MedWidth
        " No abbreviation
        return l:mode_map[l:mode][0]
    elseif winwidth(0) > g:LL_MinWidth
        " Medium abbreviation
        return l:mode_map[l:mode][1]
    else
        " Short abbrevation
        return l:mode_map[l:mode][2]
    endif
endfunction

function! LL_IsNotFile() abort "{{{2
    " Return true if not treated as file
    let exclude = [
        \ 'gitcommit',
        \ 'nerdtree',
        \ 'output',
        \ 'vista',
        \ 'undotree',
        \ 'vimfiler',
        \ 'tagbar',
        \ ]
    if index(exclude, &filetype) > -1 || index(exclude, expand('%:t')) > -1
        return 1
    endif
    return 0
endfunction

function! LL_LinePercent() abort "{{{2
    return printf('%3d%%', line('.') * 100 / line('$'))
endfunction

function! LL_LineNo() abort "{{{2
    let totlines = line('$')
    let maxdigits = len(string(totlines))
    return printf('%*d/%*d',
        \ maxdigits,
        \ line('.'),
        \ maxdigits,
        \ totlines
        \ )
endfunction

function! LL_ColNo() abort "{{{2
    return printf('%3d', virtcol('.'))
endfunction

function! LL_LineInfo() abort "{{{2
    return LL_IsNotFile() ? '' :
        \ printf('%s %s %s %s :%s',
        \ LL_LinePercent(),
        \ g:LL_LineSymbol,
        \ LL_LineNo(),
        \ g:LL_LineNoSymbol,
        \ LL_ColNo()
        \ )
endfunction

function! LL_FileType() abort "{{{2
    let ftsymbol = g:LL_nf &&
        \ exists('*WebDevIconsGetFileTypeSymbol') ?
        \ ' '.WebDevIconsGetFileTypeSymbol() :
        \ ''
    let venv = LL_VirtualEnvName()
    if winwidth(0) > g:LL_MedWidth
        return &filetype.ftsymbol.venv
    elseif winwidth(0) > g:LL_MinWidth
        return expand('%:e')
    endif
    return ''
endfunction

function! LL_FileFormat() abort "{{{2
    let ffsymbol = g:LL_nf &&
        \ exists('*WebDevIconsGetFileFormatSymbol') ?
        \ WebDevIconsGetFileFormatSymbol() :
        \ ''
    " No output if fileformat is unix (standard)
    return &fileformat !=? 'unix' ?
            \ LL_IsNotFile() ?
            \ '' : winwidth(0) > g:LL_MedWidth
            \ ? (&fileformat . ' ' . ffsymbol )
            \ : ''
        \ : ''
endfunction

function! LL_FileSize() abort "{{{2
    let div = 1024.0
    let num = getfsize(expand(@%))
    if num <= 0 | return '' | endif
    " Return bytes plain without decimal or unit
    if num < div | return num | endif
    let num /= div
    for unit in ['k', 'M', 'G', 'T', 'P', 'E', 'Z']
        if num < div
            return printf('%.1f%s', num, unit)
        endif
        let num /= div
    endfor
    " This is quite a large file!
    return printf('%.1fY')
endfunction

function! LL_FileEncoding() abort "{{{2
    " Only return a value if != utf-8
    return &fileencoding !=? 'utf-8' ? &fileencoding : ''
endfunction

function! LL_ReadOnly() abort "{{{2
    return &filetype !~? 'help' && &readonly ? g:LL_ROSymbol : ''
endfunction

function! LL_IsNerd() abort "{{{2
    return expand('%:t') =~? 'NERD_tree'
endfunction

function! LL_IsSpecialFile() abort "{{{2
    let f = @%
    let b = &buftype
    if empty(f)
        return '[No Name]'
    elseif f =~? '__Tagbar__'
        return ''
    elseif f =~? '__Gundo\|NERD_tree'
        return ''
    elseif b ==? 'quickfix'
        return '[Quickfix List]'
    elseif b =~? '^\%(nofile\|acwrite\|terminal\)$'
        return empty(f) ? '[Scratch]' : f
    elseif b ==? 'help'
        return fnamemodify(f, ':t')
    endif
    return -1
endfunction

function! LL_FileName() abort "{{{2
    let f = @%
    let special = LL_IsSpecialFile()
    if special != -1
        return special
    endif
    " Regular filename
    " Shorten it gracefully
    let p = substitute(f, expand('~'), '~', '')
    let s = p
    let numChars = winwidth(0) <= g:LL_MinWidth ? 1 :
        \ winwidth(0) <= g:LL_MedWidth ? 2 : 999
    if winwidth(0) <= g:LL_MedWidth
        let parts = split(p, '/')
        let i = 1
        for part in parts
            if i == 1
                let s = part
            elseif i == len(parts)
                let s = s.'/'.part
            else
                let s = s.'/'.part[0:numChars - 1]
            endif
            let i += 1
        endfor
    endif
    return LL_ReadOnly().s.LL_Modified()
endfunction

function! LL_FileNameShort() abort "{{{2
    " Filename only
    let f = @%
    let special = LL_IsSpecialFile()
    if special != -1
        return special
    endif
    return printf('%s%s%s', LL_ReadOnly(), expand('%:t'), LL_Modified())
endfunction

function! LL_TabName() abort "{{{2
  let fname = @%
  return fname =~? '__Tagbar__' ? 'Tagbar' :
        \ fname =~? 'NERD_tree' ? 'NERDTree' :
        \ LL_FileName()
endfunction

function! LL_GitHunkSummary() abort "{{{2
    if exists('b:coc_git_status')
        return trim(b:coc_git_status)
    elseif !exists('*GitGutterGetHunkSummary')
        return ''
    endif
    let githunks =  GitGutterGetHunkSummary()
    let added =     githunks[0] ? printf('+%d ', githunks[0])   : ''
    let changed =   githunks[1] ? printf('~%d ', githunks[1])   : ''
    let deleted =   githunks[2] ? printf('-%d ', githunks[2])   : ''
    return printf('%s%s%s',
        \ added,
        \ changed,
        \ deleted,
        \ )
endfunction

function! LL_GitBranch() abort "{{{2
    if exists('g:coc_git_status')
        return g:coc_git_status
    elseif exists('*fugitive#head')
        return g:LL_BranchSymbol.' '.fugitive#head()
    endif
    return ''
endfunction

function! LL_GitStatus() abort "{{{2
    if !LL_IsNotFile() && winwidth(0) > g:LL_MinWidth
        let branch = LL_GitBranch()
        let hunks = LL_GitHunkSummary()
        return branch !=# '' ? printf('%s%s%s',
            \ g:LL_GitSymbol,
            \ branch,
            \ hunks !=# '' ? ' '.hunks : ''
            \ ) : ''
    endif
    return ''
endfunction

function! LL_VirtualEnvName() abort "{{{2
    if exists('g:did_coc_loaded') | return '' | endif
    return &filetype ==# 'python' && !empty($VIRTUAL_ENV)
        \ ? printf(' (%s)', split($VIRTUAL_ENV, '/')[-1])
        \ : ''
endfunction

function! LL_CurrentTag() abort "{{{2
    if winwidth(0) < g:LL_MedWidth | return '' | endif
    " if get(b:, 'vista_nearest_method_or_function', '') !=# ''
    "     return get(g:vista#renderer#icons, 'function', '') . ' ' . b:vista_nearest_method_or_function . '()'
    " endif
    let coc_func = get(b:, 'coc_current_function', '')
    if coc_func !=# '' | return coc_func | endif
    if exists('*tagbar#currenttag')
        return tagbar#currenttag('%s', '', 'f')
    endif
    return ''
endfunction

function! LL_CocStatus() abort "{{{2
    if winwidth(0) > g:LL_MinWidth && get(g:, 'did_coc_loaded', 0)
        return coc#status()
    endif
    return ''
endfunction

function! LL_CocError() abort "{{{2
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info)
    return ''
  endif
  let errmsgs = []
  if get(info, 'error', 0)
    call add(errmsgs, g:LL_LinterErrors . info['error'])
  endif
  return trim(join(errmsgs, ' ') . ' ')
endfunction

function! LL_CocWarn() abort " {{{2
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info)
    return ''
  endif
  let warnmsgs = []
  if get(info, 'warning', 0)
    call add(warnmsgs, g:LL_LinterWarnings . info['warning'])
  endif
  return trim(join(warnmsgs, ' ') . ' ')
endfunction

function! LL_LinterErrors() abort " {{{2
    return LL_CocError() ==# '' ?
        \ lightline#ale#errors() :
        \ LL_CocError()
endfunction

function! LL_LinterWarnings() abort " {{{2
    return LL_CocWarn() ==# '' ?
        \ lightline#ale#warnings() :
        \ LL_CocWarn()
endfunction

" Set lightline theme
let lightline['colorscheme'] = g:statusline_theme
