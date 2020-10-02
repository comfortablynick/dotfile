" ====================================================
" Filename:    plugin/maps.vim
" Description: General keymaps
" Author:      Nick Murphy (comfortablynick@gmail.com)
" License:     MIT
" ====================================================
let s:guard = 'g:loaded_plugin_maps' | if exists(s:guard) | finish | endif
let {s:guard} = 1

" General {{{1
nnoremap U <C-r>
nnoremap qq :x<CR>
nnoremap qqq :q!<CR>
nnoremap QQ ZQ
" Clears hlsearch after doing a search, otherwise <CR>
nnoremap <expr> <CR> {-> v:hlsearch ? ":nohlsearch\<CR>" : "\<CR>"}()
tnoremap <buffer><silent> <Esc> <C-\><C-n><CR>:bw!<CR>

" Insert mode <Esc> maps {{{2
inoremap kj <Esc>`^
inoremap lkj <Esc>`^:w<CR>
inoremap ;lkj <Esc>`^:x<CR>

" Indent/outdent {{{2
vnoremap <Tab>   <Cmd>normal! >gv<CR>
vnoremap <S-Tab> <Cmd>normal! <gv<CR>

" Window navigation {{{1
" `CTRL+{h,j,k,l}` to navigate in normal mode {{{2
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" `ALT+{h,j,k,l}` to navigate windows from other modes {{{2
" Note: vim has trouble with Meta/Alt key
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l

" Delete window to the left/below/above/to the right with d<C-h/j/k/l> {{{2
nnoremap d<C-j> <C-w>j<C-w>c
nnoremap d<C-k> <C-w>k<C-w>c
nnoremap d<C-h> <C-w>h<C-w>c
nnoremap d<C-l> <C-w>l<C-w>c

" Override vim-impaired tagstack mapping {{{2
nnoremap <silent> [t :tabprevious<CR>
nnoremap <silent> ]t :tabnext<CR>

" Buffer navigation {{{1
nnoremap <silent> <Tab> :bnext<CR>
nnoremap <silent> <S-Tab> :bprevious<CR>
nnoremap <silent> <Leader>q :bd<CR>

" Quickfix
nnoremap <silent> cq :call quickfix#toggle()<CR>
nnoremap <silent> [q :cabove<CR>
nnoremap <silent> ]q :cbelow<CR>

" Command line {{{1
" %% -> cwd
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>

" vim:fdl=1 noml:
