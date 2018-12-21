" Settings for Python files

" PEP8 Compatibile Indenting
setlocal expandtab                          " Expand tab to spaces
setlocal smartindent                        " Attempt smart indenting
setlocal autoindent                         " Attempt auto indenting
setlocal shiftwidth=4                       " Indent width in spaces
setlocal softtabstop=4
setlocal tabstop=4
setlocal foldmethod=marker                  " Use {{{ for folding

" Other
setlocal backspace=2                        " Backspace behaves as expected
let python_highlight_all=1                  " Highlight all builtins
let $PYTHONUNBUFFERED=1                     " Disable stdout buffering

" Map
" Execute current file with AsyncRun
" TODO: evaluate if > 1 pane in TMUX
function! UseQuickFix() abort
    if $TMUX_SESSION ==? 'ios'
        if g:window_width < 120
            return 1
        else
            return 0
        endif
    elseif exists('$TMUX')
        return 0
    endif
endfunction

if exists('*asyncrun#quickfix_toggle')
    function! AsyncRun_Python_Cmd() abort
        if UseQuickFix()
            let scroll = get(g:, 'quickfix_run_scroll', 1)
            let raw = get(g:, 'asyncrun_raw_output', 0)
            let cmd = scroll ? ':AsyncRun' : ':AsyncRun!'
            let raw_cmd = raw ? ' -raw' : ''
            return cmd . raw_cmd . ' python3 % <CR>'
        else
            let g:asyncrun_open = 0
            let g:asyncrun_save = 1
            return ':AsyncRun tmux send-keys -t right C-l "python3 $(VIM_FILEPATH)" C-m<CR>'
        endif
    endfunction

    " TODO: only execute if available pane OR open new split
    execute 'nnoremap <silent> <C-b> ' . AsyncRun_Python_Cmd()
    nnoremap <silent> <C-x> :call ToggleQf()<CR>
else
    nnoremap <silent> <C-b> :call SaveAndExecutePython()<CR>
    nnoremap <silent> <C-x> :call ClosePythonWindow()<CR>
endif
