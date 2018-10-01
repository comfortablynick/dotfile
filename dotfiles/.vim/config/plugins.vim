" PLUGIN SETTINGS =============================== 

call plug#begin('~/.vim/plugged')                               " Plugin Manager

if has('nvim')
    " Load Neovim-only plugins
    exec 'source' vim_home . 'plugins_nvim.vim'
else
    " Load Vim-only plugins
    exec 'source' vim_home . 'plugins_vim.vim'
endif

" Editor/appearance
Plug 'airblade/vim-gitgutter'                                   " Inline git status
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }          " File explorer panel

" Linting 
Plug 'w0rp/ale'                                                 " Linting

" Syntax highlighting
Plug 'HerringtonDarkholme/yats', { 'for': 'typescript' }        " Typescript
Plug 'gabrielelana/vim-markdown', { 'for': 'markdown' }         " Markdown
" Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}          " Python (enhanced)

" Git
Plug 'junegunn/gv.vim'                                          " Git log/diff explorer
Plug 'tpope/vim-fugitive'                                       " Git wrapper

" Theming
Plug 'ayu-theme/ayu-vim'
Plug 'arcticicestudio/nord-vim'
Plug 'morhetz/gruvbox'
Plug 'NLKNguyen/papercolor-theme'

call plug#end()


" PLUGIN CONFIGURATION ==========================
" Ale linter
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s (%severity%%: code%)'
let g:ale_sign_column_always = 1
let g:ale_completion_enabled = 0
let g:ale_virtualenv_dir_names = ['.env', '.pyenv', 'env', 'dev', 'virtualenv']
let b:ale_linters = {
    \ 'python': [ 'flake8' ]
    \ }

" NERDTree
let NERDTreeHighlightCursorline = 1             " Increase visibility of line
let NERDTreeIgnore = [
    \ '\.pyc$',
    \ '^__pycache__$',
    \ '.vscode'
    \ ]
let NERDTreeShowHidden = 1                      " Show dotfiles