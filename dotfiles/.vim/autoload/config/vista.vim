" ====================================================
" Filename:    autoload/config/vista.vim
" Description: Vista explorer config
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-08 10:09:59 CST
" ====================================================
scriptencoding utf-8

" Calculate fzf preview width based on window width
function s:vista_fzf_preview_width(basewidth) abort
    let winwidth = winwidth(0)
    let pwidth = a:basewidth
    if winwidth < 225
        let pwidth = a:basewidth - (200 - winwidth)
    endif
    return insert([], printf('right:%d%%', pwidth < 0 ? 0 : pwidth))
endfunction

" Calculate sidebar width based on window width
" Too complicated; just use simple binary choice
function s:vista_sidebar_width(maxwidth, minwidth) abort
    let winwidth = winwidth(0)
    let diff = a:maxwidth - a:minwidth
    let vwidth = a:maxwidth
    if winwidth < 225
        let vwidth = float2nr(round(((1 - ((225 - winwidth)/225.0)) * diff) + a:minwidth))
    endif
    return min([vwidth, a:maxwidth])
endfunction

function! s:vista_set_opts() abort
    let g:vista_set_opts = 1
    if !exists('*fzf#vim#with_preview') | packadd fzf.vim | endif
    if (exists('*nvim_open_win') || exists('*popup_create')) && winwidth(0) > 200
        let g:vista_echo_cursor_strategy = 'floating_win'
    else
        let g:vista_echo_cursor_strategy = 'echo'
    endif

    let g:vista_echo_cursor = 0
    let g:vista_floating_delay = 1000
    let g:vista#renderer#enable_icon = 1
    let g:vista_close_on_jump = 1
    let g:vista_fzf_preview = s:vista_fzf_preview_width(50)
    let g:vista_disable_statusline = exists('g:loaded_airline') || exists('g:loaded_lightline') || exists('g:loaded_eleline')
    let g:vista_sidebar_width = winwidth(0) > 200 ? 50 : 30
    silent! packadd vista.vim
endfunction

function config#vista#run(cmd) abort
    if !exists('g:vista_set_opts')    
        call s:vista_set_opts()
    endif
    if !exists(':Vista') | return | endif
    if a:cmd ==# 'toggle'
        Vista!!
    elseif a:cmd ==# 'finder'
        Vista finder
    else
        echoerr 'Invalid vista command!'
    endif
endfunction

" Icons {{{
" Using this seems to mess up syntax highlighting in the vista window

" How each level is indented and what to prepend.
" This could make the display more compact or more spacious.
" e.g., more compact: ['▸ ', '']
" let g:vista_icon_indent = ['╰─▸ ', '├─▸ ']
" let g:vista_icon_indent = ['▸ ', '']
" let g:vista#renderer#icons = {
" \    'func': 'ƒ',
" \    'function': 'ƒ',
" \    'var': 'ʋ',
" \    'variable': 'ʋ',
" \    'const': 'c',
" \    'constant': 'c',
" \    'method': '𝑚',
" \    'package': 'p',
" \    'packages': 'p',
" \    'enum': 'e',
" \    'enumerator': 'e',
" \    'module': 'M',
" \    'modules': 'M',
" \    'type': '𝑡',
" \    'typedef': '𝑡',
" \    'types': '𝑡',
" \    'field': 'f',
" \    'fields': 'f',
" \    'macro': 'ɱ',
" \    'macros': 'ɱ',
" \    'map': '⇶',
" \    'class': 'c',
" \    'augroup': 'a',
" \    'struct': 's',
" \    'union': 'u',
" \    'member': 'm',
" \    'target': 't',
" \    'property': 'p',
" \    'interface': 'I',
" \    'namespace': 'n',
" \    'subroutine': 'ƒ',
" \    'implementation': 'I',
" \    'typeParameter': '𝑡',
" \    'default': 'd',
" \}
" }}}
