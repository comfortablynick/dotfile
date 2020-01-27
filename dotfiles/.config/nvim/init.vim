"  _       _ _         _
" (_)_ __ (_) |___   _(_)_ __ ___
" | | '_ \| | __\ \ / / | '_ ` _ \
" | | | | | | |_ \ V /| | | | | | |
" |_|_| |_|_|\__(_)_/ |_|_| |_| |_|
"
let g:use_init_lua = 1

augroup plugin_config_handler
    autocmd!
    autocmd! SourcePre * call s:source_handler(expand('<afile>'), 'pre')
    autocmd! SourcePost * call s:source_handler(expand('<afile>'), 'post')
augroup END

let g:plugin_config_files = map(
    \ split(globpath(&runtimepath, 'autoload/plugins/*'), '\n'),
    \ {_, val -> fnamemodify(val, ':t:r')}
    \ )
let g:plugins_sourced = []

function! s:source_handler(sourced, type) abort
    if a:sourced !~# '[pack|runtime]/.*/plugin' | return | endif
    if a:type ==# 'pre' | let g:plugins_sourced += [a:sourced] | endif
    let l:file = substitute(fnamemodify(tolower(a:sourced), ':t:r'), '-', '_', 'g')
    if index(g:plugin_config_files, l:file) > -1
        let l:funcname = printf('plugins#%s#%s()', l:file, a:type)
        execute 'silent! call' l:funcname
    endif
endfunction

if has('nvim') && get(g:, 'use_init_lua') == 1
    lua require 'init'
    finish
endif

" Use vim files instead
" let config_list = ['config.vim', 'functions.vim', 'map.vim', 'theme.vim']
" let g:vim_home = get(g:, 'vim_home', expand('$HOME/dotfiles/dotfiles/.vim/config/'))

" for files in config_list
"     for f in glob(g:vim_home.files, 1, 1)
"         exec 'source' f
"     endfor
" endfor

" Non-lua General Configuration
" Vim/Neovim Only {{{1
if has('nvim')
    " Neovim Only
    set inccommand=split                                        " Live substitution
    let g:python_host_prog = $NVIM_PY2_DIR                      " Python2 binary
    let g:python3_host_prog = $NVIM_PY3_DIR                     " Python3 binary
    let &shadafile =
        \ expand('$XDG_DATA_HOME/nvim/shada/main.shada')        " Location of nvim replacement for viminfofile
    let g:package_path = expand('$XDG_DATA_HOME/nvim/site/pack')
else
    " Vim Only
    set pyxversion=3                                            " Use Python3 for pyx
    let g:python3_host_prog = '/usr/local/bin/python3.7'
    let g:package_path = expand('$HOME/.vim/pack')
endif

" Augroup {{{1
" General augroup for vimrc files
" Add to this group safely throughout config
augroup vimrc
    autocmd!
augroup END

" Files/Swap/Backup {{{1
set noswapfile                                                  " Swap files if vim quits without saving
set autoread                                                    " Detect when a file has been changed outside of vim
set backupdir=/tmp/neovim_backup//                              " Store backup files

" General {{{1
filetype plugin on                                              " Allow loading .vim files for different filetypes
syntax enable                                                   " Syntax highlighting on

set encoding=utf-8                                              " Default to unicode
scriptencoding utf-8
set shell=sh                                                    " Use posix-compatible shell
colorscheme default                                             " Default colors
set hidden                                                      " Don't unload hidden buffers
set fileformat=unix                                             " Always use LF and not CRLF
set termencoding=utf-8                                          " Unicode
set synmaxcol=200                                               " Don't try to highlight if line > 200 chr
set laststatus=2                                                " Always show statusline
set showtabline=2                                               " Always show tabline
set visualbell                                                  " Visual bell instead of audible
set nowrap                                                      " Text wrapping mode
set noshowmode                                                  " Hide default mode text (e.g. -- INSERT -- below statusline)
set cmdheight=1                                                 " Add extra line for function definition
set shortmess+=c                                                " Don't suppress echodoc with 'Match x of x'
set clipboard=unnamed                                           " Use system clipboard
set nocursorline                                                " Show line under cursor's line (check autocmds)
set noruler                                                     " Line position (not needed if using a statusline plugin
set showmatch                                                   " Show matching pair of brackets (), [], {}
set updatetime=300                                              " Update more often (helps GitGutter)
set signcolumn=yes                                              " Always show; keep appearance consistent
set scrolloff=10                                                " Lines before/after cursor during scroll
set ttimeoutlen=10                                              " How long in ms to wait for key combinations (if used)
set timeoutlen=200                                              " How long in ms to wait for key combinations (if used)
set mouse=a                                                     " Use mouse in all modes (allows mouse scrolling in tmux)
set nostartofline                                               " Don't move to start of line with j/k
set conceallevel=1                                              " Enable concealing, if defined
set concealcursor=                                              " Don't conceal when cursor goes to line
set virtualedit=onemore                                         " Allow cursor to extend past line
set exrc                                                        " Load project local .vimrc
set secure                                                      " Don't execute code in local .vimrcs

" Completion {{{1
set completeopt+=preview                                        " Enable preview option for completion
set dictionary+=/usr/share/dict/words-insane                    " Dictionary file for dict completion

" Folds {{{1
set foldenable                                                  " Enable folds by default
set foldmethod=marker                                           " Fold using markers by default
set foldnestmax=5                                               " Max nested levels (default=20)

" Indents {{{1
set expandtab                                                   " Expand tab to spaces
set smartindent                                                 " Attempt smart indenting
set autoindent                                                  " Attempt auto indenting
set tabstop=4                                                   " How many spaces a tab is worth
set shiftwidth=0                                                " Columns of whitespace per indent (0 = &tabstop)
set backspace=2                                                 " Backspace behaves as expected

" Search & replace {{{1
set ignorecase                                                  " Ignore case while searching
set smartcase                                                   " Case sensitive if uppercase in pattern
set incsearch                                                   " Move cursor to matched string
set magic                                                       " Magic escaping for regex
set gdefault                                                    " Global replacement by default

" use ripgrep as grepprg
if executable('rg')
    set grepprg=rg\ --vimgrep\ --hidden\ --no-ignore-vcs
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Undo {{{1
set undodir=~/.vim/undo//                                       " Undo file directory
set undofile                                                    " Enable persistent undo

" Windows/Splits {{{1
set splitright                                                  " Split right instead of left
set splitbelow                                                  " Split below instead of above
let g:window_width = &columns                                   " Initial window size (use to determine if on iPad)

" Line numbers {{{1
set number                                                      " Show linenumbers
set relativenumber                                              " Show relative numbers (hybrid with `number` enabled)

if has('nvim')
    lua require'helpers'
    lua require'lightline'
endif

" Keymaps {{{1
" Leader key
let g:mapleader = ','

" Indent/outdent
vnoremap <Tab>   >><Esc>gv
vnoremap <S-Tab> <<<Esc>gv

" Toggle folds
noremap <Space> za

" Open all folds under cursor
noremap za zA

" `U` to redo
nnoremap U <C-r>

" Insert mode <Esc> maps
" `kj` :: escape
inoremap kj <Esc>`^

" `lkj` :: escape + save
inoremap lkj <Esc>`^:w<CR>

" `;lkj` :: escape + save + quit
inoremap ;lkj <Esc>`^:wq<CR>

" Search - CR turns off search highlighting
nnoremap <CR> :nohlsearch<CR><CR>

" Use q to close buffer on read-only files
autocmd vimrc FileType netrw,help nnoremap <silent> q :bd<CR>

" Autocommands {{{1
" Terminal
if has('nvim')
    " Start in TERMINAL mode (any key will exit)
    autocmd vimrc TermOpen * startinsert
    " `<Esc>` to exit terminal mode
    autocmd vimrc TermOpen * tnoremap <buffer> <Esc> <C-\><C-n>
    " Unmap <Esc> so it can be used to exit FZF
    autocmd vimrc FileType fzf tunmap <buffer> <Esc>
endif
