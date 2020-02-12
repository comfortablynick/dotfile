" ====================================================
" Filename:    autoload/statusline.vim
" Description: Statusline components
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-12 16:40:29 CST
" ====================================================
scriptencoding utf-8

" Variables {{{1
" Window widths {{{2
let s:MinWidth = 90                                          " Width for using some expanded sections
let s:MedWidth = 140                                         " Secondary width for some sections
let s:MaxWidth = 200                                         " Largest width for some (unnecessary) sections

" Symbols/glyphs {{{2
let s:pl = get(g:, 'LL_pl', 0)
let s:nf = get(g:, 'LL_nf', 0)
let s:LineNoSymbol = ''                                     " Use  for line; alt: '␤'
let s:GitSymbol = s:nf ? ' ' : ''                        " Use git symbol unless no nerd fonts
let s:BranchSymbol = ''                                    " Git branch symbol
let s:LineSymbol = '☰ '                                      " Is 'Ξ' ever needed?
let s:ROSymbol = s:pl ? ' ' : '--RO-- '                  " Read-only symbol
let s:ModSymbol = ' [+]'                                     " File modified symbol
let s:SimpleSep = $SUB ==# '|' ? 1 : 0                       " Use simple section separators instead of PL (no other effects)
let s:FnSymbol = 'ƒ '                                        " Use for current function

" Linter indicators {{{2
let s:LinterChecking = s:nf ? "\uf110 " : '...'
let s:LinterWarnings = s:nf ? "\uf071 " : '•'
let s:LinterErrors = s:nf ? "\uf05e " : '•'
let s:LinterOK = ''


" Functions {{{1
function! statusline#bufnr() abort
    let bufnr = bufnr('%')
    let nums = [
        \ "\u24ea",
        \ "\u2460",
        \ "\u2461",
        \ "\u2462",
        \ "\u2463",
        \ "\u2464",
        \ "\u2465",
        \ "\u2466",
        \ "\u2467",
        \ "\u2468",
        \ "\u2469",
        \ "\u2470",
        \]
    return len(nums) < bufnr ?
        \ '['.bufnr.']' :
        \ ' '.get(nums, bufnr('%'), bufnr('%')).' '
endfunction

function! statusline#mode() abort
    " l:mode_map (0 = full size, 1 = medium abbr, 2 = short abbr)
    let l:mode_map = {
        \ 'n' :     ['NORMAL','NRM','N'],
        \ 'i' :     ['INSERT','INS','I'],
        \ 'R' :     ['REPLACE','REP','R'],
        \ 'v' :     ['VISUAL','VIS','V'],
        \ 'V' :     ['V-LINE','V-LN','V-L'],
        \ "\<C-v>": ['V-BLOCK','V-BL','V-B'],
        \ 'c' :     ['COMMAND','CMD','C'],
        \ 's' :     ['SELECT','SEL','S'],
        \ 'S' :     ['S-LINE','S-LN','S-L'],
        \ "\<C-s>": ['S-BLOCK','S-BL','S-B'],
        \ 't':      ['TERMINAL','TERM','T'],
        \ }
    let l:special_modes = {
        \ 'nerdtree':       'NERD',
        \ 'netrw':          'NETRW',
        \ 'tagbar':         'TAGS',
        \ 'undotree':       'UNDO',
        \ 'vista':          'VISTA',
        \ 'qf':             '',
        \ 'coc-explorer':   'EXPLORER',
        \ 'output:///info': 'COC-INFO',
        \ 'packager':       'PACK',
        \ }
    let l:mode = get(l:mode_map, mode(), mode())
    if winwidth(0) > s:MedWidth
        " No abbreviation
        let l:mode_out = l:mode[0]
    elseif winwidth(0) > s:MinWidth
        " Medium abbreviation
        let l:mode_out = l:mode[1]
    else
        " Short abbrevation
        let l:mode_out = l:mode[2]
    endif
    return get(l:special_modes, &filetype, get(l:special_modes, @%, l:mode_out))
endfunction

function! s:line_percent() abort "{{{2
    return printf('%3d%%', line('.') * 100 / line('$'))
endfunction

function! s:line_no() abort "{{{2
    let totlines = line('$')
    let maxdigits = len(string(totlines))
    return printf('%*d/%*d',
        \ maxdigits,
        \ line('.'),
        \ maxdigits,
        \ totlines
        \ )
endfunction

function! s:col_no() abort "{{{2
    return printf('%3d', virtcol('.'))
endfunction

function! statusline#job_status() abort "{{{2
    let l:status = get(g:, 'asyncrun_status', '')
    return !empty(l:status) ? 'Job: '.l:status : ''
endfunction

function! statusline#line_info_full() abort "{{{2
    return s:is_not_file() ? '' :
        \ printf('%s %s %s %s :%s',
        \ s:line_percent(),
        \ statusline#line_pos(),
        \ s:line_no(),
        \ s:LineNoSymbol,
        \ s:col_no()
        \ )
endfunction

function! statusline#line_info() abort
    let l:line = line('.')
    let l:line_pct = l:line * 100 / line('$')
    let l:col = virtcol('.')
    return printf('%d,%d %3d%%', l:line, l:col, l:line_pct)
endfunction

function! statusline#file_type() abort "{{{2
    let l:ftsymbol = s:nf &&
        \ exists('*WebDevIconsGetFileTypeSymbol') ?
        \ ' '.WebDevIconsGetFileTypeSymbol() :
        \ ''
    let l:venv = statusline#venv_name()
    if winwidth(0) > s:MedWidth
        return &filetype.l:ftsymbol.l:venv
    elseif winwidth(0) > s:MinWidth
        let l:ext = expand('%:e')
        return &filetype ==# 'help' ? 'help' : expand('%:e')
    endif
    return ''
endfunction

function! statusline#file_format() abort "{{{2
    let ffsymbol = s:nf &&
        \ exists('*WebDevIconsGetFileFormatSymbol') ?
        \ WebDevIconsGetFileFormatSymbol() :
        \ ''
    " No output if fileformat is unix (standard)
    return &fileformat !=? 'unix' ?
            \ s:is_not_file() ?
            \ '' : winwidth(0) > s:MedWidth
            \ ? (&fileformat . ' ' . ffsymbol )
            \ : ''
        \ : ''
endfunction

function! s:is_not_file() abort "{{{2
    " Return true if not treated as file
    let exclude = [
        \ 'nerdtree',
        \ 'netrw',
        \ 'output',
        \ 'vista',
        \ 'undotree',
        \ 'vimfiler',
        \ 'tagbar',
        \ 'minpac',
        \ 'packager',
        \ 'vista',
        \ 'qf',
        \ 'coc-explorer',
        \ 'output:///info',
        \ ]
    if index(exclude, &filetype) > -1
        \ || index(exclude, expand('%:t')) > -1
        \ || index(exclude, expand('%')) > -1
        return 1
    endif
    return 0
endfunction

function! s:modified() abort "{{{2
    return &filetype =~? 'help\|vimfiler' ? '' : &modified ? s:ModSymbol : &modifiable ? '' : '-'
endfunction

function! s:read_only() abort "{{{2
    return &filetype !~? 'help' && &readonly ? s:ROSymbol : ''
endfunction

function! s:is_special_file() abort "{{{2
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
    elseif f ==# 'output:///info'
        return ''
    endif
    return -1
endfunction

function! statusline#file_name() abort "{{{2
    if s:is_not_file() | return '' | endif
    let special = s:is_special_file()
    if special != -1 | return special | endif

    let f = @%
    let s = expand('%:t')
    let ww = winwidth(0)
    if ww > s:MinWidth
        " Get full path and truncate gracefully
        let p = substitute(f, expand('~'), '~', '')
        let s = p
        let chars = ww <= s:MedWidth ? 2 :
            \ ww <= s:MaxWidth ? 3 :
            \ 999 " No truncation
        if chars < 999
            if !empty(statusline#coc_status()) | let chars -= 1 | endif
            let Shorten = { part -> part[0:chars - 1] }
            let parts = split(p, '/')
            let i = 1
            if len(parts) > 1
                for part in parts
                    if i == 1
                        let s = Shorten(part, chars)
                    elseif i == len(parts)
                        let s = s.'/'.part
                    else
                        let s = s.'/'.Shorten(part, chars)
                    endif
                    let i += 1
                endfor
            endif
        endif
    endif
    return printf('%s%s%s',
        \ s:read_only(),
        \ s,
        \ s:modified()
        \ )
endfunction

function! statusline#file_size() abort "{{{2
    let div = 1024.0
    let num = getfsize(expand('%:p'))
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

function! statusline#file_encoding() abort "{{{2
    " Only return a value if != utf-8
    return &fileencoding !=? 'utf-8' ? &fileencoding : ''
endfunction

function! statusline#tab_name() abort "{{{2
  let fname = @%
  return fname =~? '__Tagbar__' ? 'Tagbar' :
        \ fname =~? 'NERD_tree' ? 'NERDTree' :
        \ statusline#file_name()
endfunction

function! statusline#git_summary() abort "{{{2
    " Look for status in this order
    " 1. coc-git
    " 2. gitgutter
    " 3. signify
    if exists('b:coc_git_status') | return trim(b:coc_git_status) | endif
    if exists('*GitGutterGetHunkSummary')
        let githunks = GitGutterGetHunkSummary()
    elseif exists('*sy#repo#get_stats')
        let githunks = sy#repo#get_stats()
    else
        return ''
    endif
    let added =     githunks[0] ? printf('+%d ', githunks[0])   : ''
    let changed =   githunks[1] ? printf('~%d ', githunks[1])   : ''
    let deleted =   githunks[2] ? printf('-%d ', githunks[2])   : ''
    return printf('%s%s%s',
        \ added,
        \ changed,
        \ deleted,
        \ )
endfunction

function! statusline#git_branch() abort "{{{2
    let l:out = ''
    if exists('g:coc_git_status')
        let l:out = g:coc_git_status
    elseif exists('*fugitive#head')
        let l:out = s:BranchSymbol.' '.fugitive#head()
    endif
    return substitute(l:out, 'master', '', '')
endfunction

function! statusline#git_status() abort "{{{2
    if !s:is_not_file() && winwidth(0) > s:MinWidth
        let branch = statusline#git_branch()
        let hunks = statusline#git_summary()
        return branch !=# '' ? printf('%s%s%s',
            \ s:GitSymbol,
            \ branch,
            \ hunks !=# '' ? ' '.hunks : ''
            \ ) : ''
    endif
    return ''
endfunction

function! statusline#venv_name() abort "{{{2
    if exists('g:did_coc_loaded') | return '' | endif
    return &filetype ==# 'python' && !empty($VIRTUAL_ENV)
        \ ? printf(' (%s)', split($VIRTUAL_ENV, '/')[-1])
        \ : ''
endfunction

function! statusline#current_tag() abort "{{{2
    if winwidth(0) < s:MaxWidth | return '' | endif
    let coc_func = get(b:, 'coc_current_function', '')
    if coc_func !=# '' | return coc_func | endif
    if exists('*tagbar#currenttag')
        return tagbar#currenttag('%s', '', 'f')
    endif
    return ''
endfunction

function! statusline#coc_status() abort "{{{2
    if winwidth(0) > s:MinWidth && get(g:, 'did_coc_loaded', 0)
        return get(g:, 'coc_status', '')
    endif
    return ''
endfunction

function! s:coc_error() abort "{{{2
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info)
    return ''
  endif
  let errmsgs = []
  if get(info, 'error', 0)
    call add(errmsgs, s:LinterErrors . info['error'])
  endif
  return trim(join(errmsgs, ' ') . ' ')
endfunction

" function! s:ale_error() abort "{{{2
"     if exists('*ale#statusline#Count')
"
" endfunction

function! s:coc_warn() abort " {{{2
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info)
    return ''
  endif
  let warnmsgs = []
  if get(info, 'warning', 0)
    call add(warnmsgs, s:LinterWarnings . info['warning'])
  endif
  return trim(join(warnmsgs, ' ') . ' ')
endfunction

function! statusline#linter_errors() abort " {{{2
    let coc = s:coc_error()
    return empty(coc) ?
        \ lightline#ale#errors() :
        \ coc
endfunction

function! statusline#linter_warnings() abort " {{{2
    let coc = s:coc_warn()
    return empty(coc) ?
        \ lightline#ale#warnings() :
        \ coc
endfunction

" vim:fdm=expr:
