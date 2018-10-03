" VIM / NEOVIM FUNCTIONS

" Add shebang for new file
function! SetShebang()
python3 << endpython

import vim
shebang = {
	'python':     '#!/usr/bin/env python3',
	'sh':         '#!/usr/bin/env sh',
	'javascript': '#!/usr/bin/env node',
	'lua':        '#!/usr/bin/env lua',
	'ruby':       '#!/usr/bin/env ruby',
	'perl':       '#!/usr/bin/env perl',
	'php':        '#!/usr/bin/env php',
        'fish':       '#!/usr/bin/env fish',
}
if not vim.current.buffer[0].startswith('#!'):
	filetype = vim.eval('&filetype')
	if filetype in shebang:
		vim.current.buffer[0:0] = [ shebang[filetype] ]
endpython
endfunction


" Get path of current file
function! GetPath()
python3 << EOP

import vim

file_path = vim.eval("expand('%:p')")
print(file_path)
EOP
endfunction


" Set executable bit
function! SetExecutableBit()
python3 << EOP

import os
import stat
import vim

file_path = vim.eval("expand('%:p')")
st = os.stat(file_path)
old_perms = stat.filemode(st.st_mode)
os.chmod(file_path, st.st_mode | 0o111)
new_st = os.stat(file_path)
new_perms = stat.filemode(new_st.st_mode)

if old_perms == new_perms:
    print(f"File already executable: {old_perms}")
else:
    print(f"File now executable; changed from {old_perms} to {new_perms}")
EOP
endfunction


" Set shebang and executable bit
function! SetExecutable()
    call SetExecutableBit()
    call SetShebang()
endfunction


" Run Python Code in Vim
" 
" Bind Ctrl+b to save file if modified and execute python script in a buffer.
nnoremap <silent> <C-b> :call SaveAndExecutePython()<CR>
vnoremap <silent> <C-b> :<C-u>call SaveAndExecutePython()<CR>

function! SaveAndExecutePython()
    " SOURCE [reusable window]: https://github.com/fatih/vim-go/blob/master/autoload/go/ui.vim

    " save and reload current file
    silent execute "update | edit"

    " get file path of current file
    let s:current_buffer_file_path = expand("%")

    let s:output_buffer_name = "Python"
    let s:output_buffer_filetype = "output"

    " reuse existing buffer window if it exists otherwise create a new one
    if !exists("s:buf_nr") || !bufexists(s:buf_nr)
        silent execute 'botright new ' . s:output_buffer_name
        let s:buf_nr = bufnr('%')
    elseif bufwinnr(s:buf_nr) == -1
        silent execute 'botright new'
        silent execute s:buf_nr . 'buffer'
    elseif bufwinnr(s:buf_nr) != bufwinnr('%')
        silent execute bufwinnr(s:buf_nr) . 'wincmd w'
    endif

    silent execute "setlocal filetype=" . s:output_buffer_filetype
    setlocal bufhidden=delete
    setlocal buftype=nofile
    setlocal noswapfile
    setlocal nobuflisted
    setlocal winfixheight
    setlocal cursorline " make it easy to distinguish
    setlocal nonumber
    setlocal norelativenumber
    setlocal showbreak=""

    " clear the buffer
    setlocal noreadonly
    setlocal modifiable
    silent %delete _

    " add the console output
    silent execute ".!python3 " . shellescape(s:current_buffer_file_path, 1)

    " make the buffer non modifiable
    setlocal readonly
    setlocal nomodifiable

    " Return to previous (code) window
    silent execute 'wincmd p'
endfunction
