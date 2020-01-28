" Quickfix window functions
" Toggle quickfix window
if exists('g:loaded_autoload_quickfix') | finish | endif
let g:loaded_autoload_quickfix = 1

" Originally from:
" https://github.com/skywind3000/asyncrun.vim/blob/master/plugin/asyncrun.vim
function! s:qf_toggle(size, ...)
    let l:mode = (a:0 == 0)? 2 : (a:1)
    function! s:window_check(mode)
        if &l:buftype ==# 'quickfix'
            let s:quickfix_open = 1
            return
        endif
        if a:mode == 0
            let w:quickfix_save = winsaveview()
        else
            if exists('w:quickfix_save')
                call winrestview(w:quickfix_save)
                unlet w:quickfix_save
            endif
        endif
    endfunc
    let s:quickfix_open = 0
    let l:winnr = winnr()
    noautocmd windo call s:window_check(0)
    noautocmd silent! execute ''.l:winnr.'wincmd w'
    if l:mode == 0
        if s:quickfix_open != 0
            silent! cclose
        endif
    elseif l:mode == 1
        if s:quickfix_open == 0
            execute 'botright copen '. ((a:size > 0)? a:size : ' ')
            wincmd k
        endif
    elseif l:mode == 2
        if s:quickfix_open == 0
            execute 'botright copen '. ((a:size > 0)? a:size : ' ')
            wincmd k
        else
            silent! cclose
        endif
    endif
    noautocmd windo call s:window_check(1)
    noautocmd silent! exec ''.l:winnr.'wincmd w'
endfunction

function! quickfix#toggle() abort
    let l:qf_lines = len(getqflist())
    let l:qf_size = min([max([1, qf_lines]), get(g:, 'quickfix_size', 12)])
    call s:qf_toggle(l:qf_size)
endfunction

" Close an empty quickfix window
function! quickfix#close_empty() abort
    if len(getqflist())
        return
    endif
    for buffer in tabpagebuflist()
        if bufname(buffer) ==? ''
            call quickfix#toggle()
            return
        endif
    endfor
endfunction

" Return 1 if quickfix window is open, else 0
function! quickfix#is_open() abort
    for buffer in tabpagebuflist()
        if bufname(buffer) ==? ''
            return 1
        endif
    endfor
    return 0
endfunction

" Close quickfix on quit
" (Use autoclose script instead)
function! quickfix#autoclose() abort
    if &filetype ==? 'qf'
        " if this window is last on screen quit without warning
        if winnr('$') < 2
            quit
        endif
    endif
endfunction
