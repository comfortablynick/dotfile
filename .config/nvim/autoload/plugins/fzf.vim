" Config {{{1
let g:fzf_history_dir = stdpath('data') .. '/fzf'

let g:fzf_prefer_tmux = get(g:, 'fzf_prefer_tmux', v:true)

if exists('$TMUX') && g:fzf_prefer_tmux
    " See `man fzf-tmux` for available options
    let g:fzf_layout = {'tmux': '-p90%,60%'}
else
    let g:fzf_layout = {'window': {'width': 0.9, 'height': 0.6}}
    " let g:fzf_layout = {'down': '40%'}
endif

let g:fzf_colors = {
    \ 'fg':      ['fg', 'Normal'],
    \ 'bg':      ['bg', 'Clear'],
    \ 'hl':      ['fg', 'Comment'],
    \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
    \ 'hl+':     ['fg', 'Statement'],
    \ 'info':    ['fg', 'PreProc'],
    \ 'prompt':  ['fg', 'Conditional'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment']
    \ }

augroup fzf_config "{{{2
    autocmd!
    autocmd FileType fzf silent! tunmap <buffer> <Esc>
augroup END

nnoremap z= <Cmd>call <SID>fzf_spell()<CR>

" Functions {{{1
function s:fzf_rg(query, fullscreen) "{{{2
    let l:cmd = printf(
        \ 'rg --column --line-number --no-heading --color=always --smart-case %s || true',
        \ shellescape(a:query)
        \ )
    let l:rg = {}
    let l:rg.source = l:cmd
    let l:rg.sinklist = {val->s:grep_handler(val, l:cmd)}
    let l:rg.options = 
        \ '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : --nth 4.. '.
        \ '--multi --bind=ctrl-a:select-all,ctrl-d:deselect-all '.
        \ '--color hl:68,hl+:110 --prompt="Rg> "'
    let l:rg = fzf#vim#with_preview(
        \ fzf#wrap('rg', l:rg, a:fullscreen),
        \ a:fullscreen ? 'up:60%' : 'right:60%',
        \ '?'
        \ )
    call fzf#run(l:rg)
endfunction

" Use `rg` to filter, passing through to fzf as a selector
function s:fzf_rg_passthrough(query, fullscreen) "{{{2
    let l:command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
    let l:initial_command = printf(l:command_fmt, shellescape(a:query))
    let l:reload_command = printf(l:command_fmt, '{q}')
    let l:spec = {
        \ 'options': [
        \    '--prompt', 'RG> ',
        \    '--phony',
        \    '--query', a:query,
        \    '--bind',
        \    'change:reload:' .. l:reload_command,
        \ ]}
    call fzf#vim#grep(
        \ l:initial_command,
        \ 1,
        \ fzf#vim#with_preview(l:spec, a:fullscreen ? 'up:60%' : 'right:60%', '?'),
        \ a:fullscreen
        \ )
endfunction

function s:fzf_mru(fullscreen) "{{{2
    let l:mru = {}
    let l:mru.source = luaeval('require("tools").mru_files()')
    let l:mru.sink = 'edit'
    let l:mru.options = '--color hl:68,hl+:110 --prompt="MRU> "'

    let l:mru = fzf#vim#with_preview(
        \ fzf#wrap('mru', l:mru, a:fullscreen),
        \ a:fullscreen ? 'up:60%' : 'right:60%',
        \ '?',
        \ )
    call fzf#run(l:mru)
endfunction

function s:fzf_globals(fullscreen) "{{{2
    let l:globals = map(sort(keys(g:)), {_,v -> 'g:'..v})
    let l:spec = {}
    let l:spec.source = l:globals
    let l:spec.sink = ''
    let l:spec.options = '--color hl:68,hl+:110 --prompt="Globals> "'
    call fzf#run(fzf#wrap('globals', l:spec, a:fullscreen))
endfunction

function s:fzf_scriptnames(fullscreen) "{{{2
    let l:spec = {}
    let l:preview_cmd =  substitute(fzf#vim#with_preview()['options'][1], '{}', '{2..-1}', '')
    let l:preview_pos = a:fullscreen ? 'up:60%' : 'right:60%'
    let l:spec.source = split(execute('scriptnames'), '\n')
    let l:spec.sink = {sel->execute('edit '..trim(split(sel, ' ')[-1]))}
    let l:spec.options = '--preview-window ' .. l:preview_pos .. 
        \ ' --preview "' .. l:preview_cmd .. '"' ..
        \ ' --multi ' ..
        \ ' --bind ?:toggle-preview' ..
        \ ' --color hl:68,hl+:110 --prompt="Scriptnames> "'
    let l:spec = fzf#wrap('scriptnames', l:spec, a:fullscreen)
    call fzf#run(l:spec)
endfunction

function s:fzf_asynctasks(fullscreen) "{{{2
    function! s:sink(sel)
        let g:sel = a:sel
        echo a:sel
        let l:name = split(a:sel, '<')[0]
        let l:name = substitute(l:name, '^\s*\(.\{-}\)\s*$', '\1', '')
        echo l:name
    endfunction

    if exists('*asynctasks#list') == 0
        Load asynctasks.vim
    endif
    let l:list = asynctasks#list('')
    let l:source = []
    for l:item in l:list
        let l:source += [l:item['name'].'  <'.l:item['scope'].'>  : '.l:item['command']]
    endfor
    let g:source = l:source
    let l:tasks = {}
    let l:tasks.source = l:source
    " let l:tasks['sink'] = {sel->execute('AsyncTask '..trim(fnameescape(split(sel, '<')[0])))}
    " let l:tasks['sink'] = {sel -> s:sink(sel)}
    let l:tasks.sink = {sel->execute('echo '..sel)}
    let l:tasks.options = '+m --nth 1 --inline-info --tac --prompt="AsyncTasks> "'
    call fzf#run(fzf#wrap('asynctasks', l:tasks, a:fullscreen))
endfunction

function s:fzf_spell() "{{{2
    let l:spec = {}
    let l:spec.source = spellsuggest(expand('<cword>'))
    let l:spec.sink = {word -> execute('normal! "_ciw'.word)}
    let l:spec.tmux = '-p20%,30% -x' .. wincol() .. ' -y' .. winline()
    let l:spec.window = {'width': 0.4, 'height': 0.3}
    return fzf#run(l:spec)
endfunction

function s:grep_to_qf(line) "{{{2
    let l:parts = split(a:line, ':')
    return {'filename': l:parts[0], 'lnum': l:parts[1], 'col': l:parts[2],
        \ 'text': join(l:parts[3:], ':')}
endfunction

function s:grep_handler(lines, name) "{{{2
    if len(a:lines) < 2 | return | endif

    let l:cmd = get({'ctrl-x': 'split',
        \ 'ctrl-v': 'vertical split',
        \ 'ctrl-t': 'tabe'}, a:lines[0], 'e')
    let l:list = map(a:lines[1:], {_,v->s:grep_to_qf(v)})

    let l:first = l:list[0]
    execute l:cmd escape(l:first.filename, ' %#\')
    execute l:first.lnum
    execute 'normal!' l:first.col .. '|zz'

    if !empty(l:list)
        call setqflist([], ' ', {'items': l:list, 'title': a:name})
        copen
        wincmd p
    endif
endfunction

function s:map_types_completion(a,l,p) "{{{2
    return ['n', 'i', 'o', 'x', 'v', 's', 'c', 't']
endfunction

" Commands {{{1
" Map :: View maps in any mode {{{2
command -bang -nargs=1 -complete=customlist,s:map_types_completion Map
    \ call fzf#vim#maps(<q-args>, <bang>0)

" Rg :: grep with preview window {{{2
"   :Rg - Start fzf with hidden preview window that can be enabled with `?` key
"   :RG - Execute rg with every change in search term (no fuzzy filter)
"     ! - Start fzf in fullscreen and display the preview window above
" command! -bang -nargs=* Rg call s:fzf_rg(<q-args>, <bang>0)
command -bang -nargs=* RG call s:fzf_rg_passthrough(<q-args>, <bang>0)

" Ag :: grep with preview window {{{2
"   :Ag  - Start fzf with hidden preview window that can be enabled with `?` key
"   :Ag! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Ag
    \ call fzf#vim#ag(<q-args>,
    \ <bang>0 ? fzf#vim#with_preview('up:60%')
    \ : fzf#vim#with_preview('right:60%:hidden', '?'),
    \ <bang>0
    \ )

" Files :: files list with preview window {{{2
" command! -bang -nargs=* -complete=dir Files
"     \ call fzf#vim#files(<q-args>,
"     \ <bang>0 ? fzf#vim#with_preview('up:60%')
"     \ : fzf#vim#with_preview('right:60%', '?'),
"     \ <bang>0)

" Mru :: most recently used files {{{2
command -bang Mru call s:fzf_mru(<bang>0)


" Sourced :: fuzzy :scriptnames {{{2
command -bang -nargs=* Sourced call s:fzf_scriptnames(<bang>0)
command -bang -nargs=* Tasks call s:fzf_asynctasks(<bang>0)

" vim:fdl=1:
