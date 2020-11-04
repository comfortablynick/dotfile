" Clap setup {{{1
" General settings
let g:clap_multi_selection_warning_silent = 1
let g:clap_enable_icon = 1
let g:clap_preview_size = 10
" let g:clap_use_pure_python = 1  " Set this if vim crashes when looking at files

" Commands 
command! Task  :Clap task
command! Filer :Clap filer

" Maps
nnoremap <silent> <Leader>t :Clap tags<CR>
nnoremap <silent> <Leader>h :Clap command_history<CR>

" Autocommands {{{2
function s:clap_on_enter() "{{{3
    augroup ClapEnsureAllClosed
        autocmd!
        autocmd BufEnter,WinEnter,WinLeave * ++once call clap#floating_win#close()
    augroup END
    call s:clap_win_disable_fold()
    if exists('g:loaded_mucomplete')
        silent! MUcompleteAutoOff
        let s:mucomplete_disabled = 1
    endif
endfunction

function s:clap_on_exit() "{{{3
    if exists('s:mucomplete_disabled')
        silent! MUcompleteAutoOn
        unlet s:mucomplete_disabled
    endif
endfunction

function s:clap_win_disable_fold() "{{{3
    let l:clap = get(g:, 'clap')
    if empty(l:clap) | return | endif
    let l:winid = l:clap['display']['winid']
    call setwinvar(l:winid, '&foldenable', 0)
endfunction

augroup autoload_plugins_clap "{{{3
    autocmd!
    " Set autocmd to close clap win if we leave
    autocmd User ClapOnEnter call s:clap_on_enter()
    autocmd User ClapOnExit call s:clap_on_exit()
augroup END

" Functions {{{1
" function plugins#clap#get_selected() :: Get selection sans icon {{{2
function plugins#clap#get_selected()
    let l:curline = g:clap.display.getcurline()
    if g:clap_enable_icon
        let l:curline = l:curline[4:]
    endif
    return l:curline
endfunction

" function plugins#clap#file_preview() :: File preview with icon support {{{2
function plugins#clap#file_preview()
    let l:curline = plugins#clap#get_selected()
    return clap#preview#file(l:curline)
endfunction

" function plugins#clap#file_edit() :: File edit with icon support {{{2
function plugins#clap#file_edit(selected)
    let l:fname = g:clap_enable_icon ?
        \ a:selected[4:] :
        \ a:selected
    execute 'edit' l:fname
endfunction

" history (lua/Viml test) {{{1
function plugins#clap#history() "{{{2
    let l:hist = filter(
        \ map(range(1, histnr(':')), {v-> histget(':', - v)}),
        \ {v-> !empty(v)}
        \ )
    let l:cmd_hist_len = len(l:hist)
    return map(l:hist, {k,v-> printf('%4d', l:cmd_hist_len - k).'  '.v})
endfunction

function plugins#clap#history_lua() "{{{2
    return luaeval('require("tools").get_history_clap()')
endfunction
" vim:fdl=1:
