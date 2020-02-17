if exists('g:loaded_autoload_plugins_tcomment') | finish | endif
let g:loaded_autoload_plugins_tcomment = 1

function! plugins#tcomment#post() abort
    " Add additional mappings for nerdcomment muscle memory
    xmap <silent><Leader>c          <Plug>TComment_gc
    nmap <Leader>c<Space>           <Plug>TComment_gcc
    omap <silent><Leader>c          <Plug>TComment_gc

    " Map any syntax regions tcomment doesn't get right
    let g:tcomment#filetype#syntax_map_user = {
        \ 'vimLuaRegion': 'lua',
        \ }
endfunction