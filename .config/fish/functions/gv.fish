# Defined in /home/nick/.config/fish/env.fish @ line 177
function gv --description 'alias view current repo using gv.vim'
 $EDITOR +"packadd vim-fugitive" +"packadd gv.vim" +GV +"autocmd BufWipeout <buffer> qall"; 
end