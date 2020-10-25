" TODO: replace with framework like asynctasks?
let g:use_term = 0                                              " Use term instead of Vtr/AsyncRun
let g:run_cmd_in = 'vtr'
let g:VtrStripLeadingWhitespace = 0                             " Useful for Python to avoid messing up whitespace
let g:VtrClearEmptyLines = 0                                    " Disable clearing if blank lines are relevant
let g:VtrAppendNewline = 1                                      " Add newline to multiline send
let g:VtrOrientation = 'h'                                      " h/v split
let g:VtrPercentage = 40                                        " Percent of tmux window the runner pane with occupy

" Put filetypes here if we need to pause between
" saving and executing the command
let s:wait_before_run_fts = ['rust']

let g:runner_cmd_overrides = {
    \ 'lua': 'just runfile {file}',
    \}

function! s:run(cmd)
    let l:time = index(s:wait_before_run_fts, &filetype) > -1 ? 500 : 0
    if &l:modified | write | endif
    call timer_start(l:time, {-> runner#run_cmd(a:cmd)})
endfunction

nmap <silent> <Leader>z <Plug>(VtrAttachToPane)
nmap <silent> <Leader>x <Plug>(VtrKillRunner)

nnoremap <silent> <Leader>r :call runner#run_cmd('run')<CR>
nnoremap <silent> <Leader>i :call <SID>run('install')<CR>
nnoremap <silent> <Leader>b :call runner#run_cmd('build')<CR>
nnoremap <silent> <Leader><Leader>b :call runner#run_cmd('bench')<CR>
nnoremap <silent> <Leader><Leader>t :call runner#run_cmd('test')<CR>
