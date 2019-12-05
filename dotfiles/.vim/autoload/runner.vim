" ====================================================
" Filename:    autoload/runner.vim
" Description: Run code actions based on justfile
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-12-04
" ====================================================

" Build command based on file type and command type
function! runner#run_cmd(cmd_type) abort
    let l:cmd = 'just '.a:cmd_type
    let l:run_loc = runner#get_cmd_run_loc()
    if l:run_loc ==? 'term'
        call runner#run_in_term(l:cmd)
    elseif l:run_loc ==? 'AsyncRun'
        execute 'AsyncRun '.l:cmd
        return
    elseif l:run_loc ==? 'Vtr'
        execute 'VtrSendCommandToRunner! '.l:cmd
        return
    endif
endfunction

" Use AsyncRun to run and display results in quickfix
function! runner#asyncrun(cmd) abort
endfunction

" Send cmd output to integrated terminal buffer
function! runner#run_in_term(cmd) abort
    let s:mod = winwidth(0) > 150 ? 'vsplit' : 'split'
    execute s:mod . '|term ' . a:cmd
    return
endfunction

" Determine default command output
function! runner#get_cmd_run_loc() abort
    if !exists('b:run_cmd_in')
        if exists('g:run_cmd_in')
            let b:run_cmd_in = g:run_cmd_in
        elseif !empty($TMUX_PANE) && winwidth(0) > 200
            let b:run_cmd_in = 'Vtr'
        else
            " Use built-in terminal
            let b:run_cmd_in = 'term'
        endif
    endif
    return b:run_cmd_in
endfunction
