if exists('g:loaded_autoload_plugins_clap') | finish | endif
let g:loaded_autoload_plugins_clap = 1

function! plugins#clap#post() abort
    " General settings
    let g:clap_multi_selection_warning_silent = 1
    let g:clap_enable_icon = $MOSH_CONNECTION == 0

    let g:clap_provider_alias = {
        \ 'map': 'map',
        \ 'scriptnames': 'scriptnames',
        \ }

    " Maps
    nnoremap <silent> <Leader>t :Clap tags<CR>
    nnoremap <silent> <Leader>h :Clap command_history<CR>
    nnoremap <silent> <Leader>c :Clap quick_cmd<CR>
endfunction

function! s:clap_on_enter() abort
    augroup ClapEnsureAllClosed
        autocmd!
        autocmd BufEnter,WinEnter,WinLeave * ++once call clap#floating_win#close()
    augroup END
    call s:clap_win_disable_fold()
    if exists('g:loaded_mucomplete')
        MUcompleteAutoOff
        let s:mucomplete_disabled = 1
    endif
endfunction

function! s:clap_on_exit() abort
    if exists('s:mucomplete_disabled')
        MUcompleteAutoOn
        unlet s:mucomplete_disabled
    endif
endfunction

function! s:clap_win_disable_fold() abort
    let l:clap = get(g:, 'clap')
    if empty(l:clap) | return | endif
    let l:winid = l:clap['display']['winid']
    call nvim_win_set_option(l:winid, 'foldenable', v:false)
endfunction

augroup autoload_plugins_clap
    autocmd!
    " Set autocmd to close clap win if we leave
    autocmd User ClapOnEnter call s:clap_on_enter()
    autocmd User ClapOnExit call s:clap_on_exit()
augroup END

" Clap providers {{{1
" Map :: show defined maps for all modes {{{2
" Keep this for now; built-in `maps` provider
" is confusing with which mode is shown
let s:map = {}
let s:map.source = {-> split(execute('map'), '\n')}
let s:map.sink = {-> v:null}
let g:clap#provider#map# = s:map

" Help :: search help tags and open help tab {{{2
let s:help = {}

function! s:help.source() abort
    let l:lst = []
    for l:rtp in split(&runtimepath, ',')
        let l:path = glob(l:rtp.'/'.'doc/tags')
        if filereadable(l:path)
            let l:tags = map(readfile(l:path), {_,v-> split(v)[0]})
            call extend(l:lst, l:tags)
        endif
    endfor
    return l:lst
endfunction

let s:help.on_enter = {-> g:clap.display.setbufvar('&ft', 'clap_help')}
let s:help.sink = {v-> execute(editor#help_tab().' '.v)}
let g:clap#provider#help# = s:help

" Cmd :: Frequently used commands {{{2
let s:cmds = {
    \ 'ALEInfo': 'ALE debugging info',
    \ 'CocConfig': 'Coc configuration',
    \ 'Scriptnames': 'Runtime scripts sourced',
    \ }
let s:cmd = {}
let s:cmd.source = keys(s:cmds)

function! s:cmd.on_move() abort
    let l:curline = g:clap.display.getcurline()
    call g:clap.preview.show([s:cmd.source[l:curline]])
endfunction

let s:cmd.sink = {v-> execute(v, '')}
let g:clap#provider#quick_cmd# = s:cmd

" Scriptnames :: similar to :Scriptnames {{{2
let s:scriptnames = {}
function! s:scriptnames.source() abort
    let l:names = execute('scriptnames')
    return split(l:names, '\n')
endfunction

function! s:scriptnames.sink(selected) abort
    let l:fname = split(a:selected, ' ')[-1]
    execute 'edit' trim(l:fname)
endfunction

let g:clap#provider#scriptnames# = s:scriptnames

" Dot :: open dotfiles quickly {{{2
let s:dot = {
    \ 'source': [
    \     '$DOTFILES/.config/nvim/init.vim',
    \     '$DOTFILES/bashrc.sh',
    \     '$DOTFILES/.config/tmux/tmux.conf',
    \ ],
    \ 'sink': 'e',
    \ }
let g:clap#provider#dot# = s:dot

" History (lua/Viml test) {{{2
function! plugins#clap#history() abort
    let l:hist = filter(
        \ map(range(1, histnr(':')), {v-> histget(':', - v)}),
        \ {v-> !empty(v)}
        \ )
    let l:cmd_hist_len = len(l:hist)
    return map(l:hist, {k,v-> printf('%4d', l:cmd_hist_len - k).'  '.v})
endfunction

" Much faster lua implementation
function! plugins#clap#history_lua() abort
    return luaeval('require("tools").get_history()')
endfunction
" vim:fdl=1: