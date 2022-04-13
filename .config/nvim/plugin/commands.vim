" Grep {{{1
" General commands/aliases {{{1
" S :: save if file has changed and re-run {{{2
" Use asynctasks task runner to determine command based on filetype
command S AsyncTask file-run

" Bdelete[!] :: delete buffer without changing window layout {{{2
" With [!], do not preserve window layout
command -bang -nargs=? -complete=buffer Bdelete call buffer#sayonara(<bang>0)

" BufOnly[!] :: keep only current buffer (! forces close) {{{2
command -bang BufOnly call buffer#only({'bang': <bang>0})

" Bclose[!] :: close buffers with common options {{{2
" TODO: does this take the place of BufOnly?
command -nargs=1 -bang -complete=customlist,buffer#close_complete
    \ Bclose call buffer#close(<bang>0, <q-args>)

" CopyMode :: get rid of window decorations for easy copying from hterm {{{2
command CopyMode set signcolumn=no nonumber norelativenumber

" Scratch[ify] :: convert to scratch buffer or create scratch window {{{2
command Scratchify setlocal nobuflisted noswapfile buftype=nofile bufhidden=delete
command -nargs=* -complete=command Scratch call window#open_scratch(<q-mods>, <q-args>)

" StripWhiteSpace :: remove trailing whitespace {{{2
command StripWhiteSpace call util#preserve('%s/\s\+$//e')

" he[g] :: Open help[grep] in new or existing tab {{{2
call map#cabbr('he', function('window#tab_mod', ['help', 'help']))
call map#cabbr('heg', function('window#tab_mod', ['helpgrep', 'help']))

" pyp :: Python3 print {{{2
call map#cabbr('pyp', 'py3 print()<Left><C-R>=map#eatchar(''\s'')<CR>')

" man :: Open :Man in new or existing tab {{{2
call map#cabbr('man', function('window#tab_mod', ['Man', 'man']))

" [v|h]t :: Open vertical or horizontal split terminal
call map#cabbr('vt', 'vsplit \| terminal')
call map#cabbr('ht', 'split \| terminal')

" fff :: Insert comment with fold marker {{{2
inoreabbrev fff <C-R>=syntax#foldmarker()<CR><C-R>=map#eatchar('\s')<CR>

" Root :: Change to root dir using lua {{{2
command Root silent lcd `=luaeval("require'util'.get_current_root()")`

" Misc commonly mistyped commands {{{2
command WQ wq
command Wq wq
command Wqa wqa
command W w

call map#cabbr('ehco', 'echo')
call map#cabbr('q@', 'q!')

" Misc command abbreviations {{{2
call map#cabbr('grep', 'silent grep!')
call map#cabbr('make', 'silent make!')
call map#cabbr('vh', 'vert help')
call map#cabbr('hg', 'helpgrep')


" Grep :: async grep {{{2
" command! -nargs=+ -complete=file_in_path -bar Grep
"     \ AsyncRun -strip -program=grep <args>

" Git {{{1
" TigStatus {{{2
call map#cabbr('ts', 'TigStatus')

" LazyGit :: tui for git {{{2
command -bang -nargs=* LazyGit
    \ call floaterm#run('new', <bang>0, '--width=0.9', '--height=0.6', 'lazygit')

" Utilities {{{1
" StartupTime :: lazy load startuptime.vim plugin {{{2
command! -nargs=* -complete=file Startup
    \ call pack#lazy_run(
    \   'StartupTime',
    \   'vim-startuptime',
    \   {'before': 'silent! delcommand StartupTime'}
    \ )

" Scriptease :: lazy load vim-scriptease plugin {{{2
command! -nargs=* -complete=expression PP
    \ call pack#lazy_run(
    \ 'echo scriptease#dump('..<q-args>..', #{width: 60})',
    \ 'vim-scriptease'
    \ )

" Redir :: send output of <expr> to scratch window {{{2
" Usage:
"   :Redir hi .........show the full output of command ':hi' in a scratch window
"   :Redir !ls -al ....show the full output of command ':!ls -al' in a scratch window
command! -nargs=1 -complete=command Redir silent call util#redir(<q-args>)

" Scriptnames :: display :scriptnames in quickfix and optionally filter {{{2
command! -nargs=* -bar -count=0 Scriptnames
    \ call qf#scriptnames(<f-args>)
    \| call qf#open(#{size: <count>, stay: v:false})

" Pretty-printing {{{2
" nvim: Using Lua vim.inspect()
command -complete=expression -nargs=1 LPrint echo v:lua.vim.inspect(<args>)

" Using python pformat (handles lists better but does not convert all vim types
command -complete=expression -nargs=1 PPrint echo util#pformat(<args>)

" Use custom json converter and shell out to `jq` to format
command -complete=expression -nargs=1 JPrint echo util#json_format(<args>)

" [H]elp :: floating help window {{{2
command -complete=help -nargs=? Help lua require'window'.floating_help(<q-args>)
call map#cabbr('H', 'Help')

" LspLog :: open lsp log {{{2
command LspLog edit `=v:lua.vim.lsp.get_log_path()`

" Lua {{{2
call map#cabbr('l', 'lua')
call map#cabbr('lp', 'lua p()<Left><C-R>=map#eatchar(''\s'')<CR>')

" Option :: pretty print option info {{{2
command -nargs=1 -complete=option Option echo luaeval('vim.inspect(vim.api.nvim_get_option_info(_A[1]))', [<q-args>])

" vim:fdl=1:
