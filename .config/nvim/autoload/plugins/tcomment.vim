" Add additional mappings for nerdcomment muscle memory
xmap <silent><Leader>c          <Plug>TComment_gc
nmap <silent><Leader>c<Space>   <Plug>TComment_gcc
omap <silent><Leader>c          <Plug>TComment_gc

" Map any syntax regions tcomment doesn't get right
let g:tcomment#filetype#syntax_map_user = {
    \ 'vimLuaRegion': 'lua',
    \ }
