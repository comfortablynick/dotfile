# File generated from env.toml: 2019-01-02 16:17:32
export PATH=usr/local/go/bin:$PATH
export PATH=$HOME/go/bin:$PATH
export PATH=$HOME/bin:$PATH
export PATH=$HOME/git/python/shell:$PATH
export PATH=$XDG_CONFIG_HOME/bash/functions:$PATH
export PATH=$XDG_CONFIG_HOME/shell/functions:$PATH
export PATH=$(echo -n $PATH | awk -v RS=: -v ORS=: '!x[$0]++' | sed "s/\(.*\).\{1\}/\1/")
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local
export LC_ALL=en_US.utf-8
export BROWSER=w3m
export CLICOLOR=1
export NERD_FONTS=1
export LS_AFTER_CD=1
export TODOTXT_CFG_FILE=$HOME/Dropbox/todo/todo.cfg
export VENV_DIR=$HOME/.env
export def_venv=$VENV_DIR/dev
export NVIM_PY2_DIR=$HOME/.env/nvim2/bin/python
export NVIM_PY3_DIR=$HOME/.env/nvim3/bin/python
export VISUAL=nvim
export EDITOR=$VISUAL
export VIM_COLOR=PaperColor-dark
export NVIM_COLOR=PaperColor-dark
export FZF_TMUX=1
export FZF_TMUX_HEIGHT=30%
export GOPATH=$HOME/go
alias xo=xonsh
alias lp=lpass
alias vcp='vcprompt -f "%b %r %p %u %m"'
alias vw=view
alias z=j
alias g=git
alias ga='git add'
alias gc='git commit'
alias gpl='git pull'
alias gph='git push'
alias gs='git show'
alias gcp='git commit && git push'
alias gac='git add . && git commit'
alias gsync='git pull && git add . && git commit && git push'
alias gco='git checkout master'
alias gd='git diff'
alias gdf='git diff'
alias gdiff='git diff'
alias gst='git status -s'
alias glog='vim +GV'
alias grst='git reset --hard origin/master'
alias gsub='git submodule foreach --recursive git pull origin master'
alias gunst='git reset HEAD'
alias grmi='git rm --cached'
alias h=$HOME
alias gpy=$HOME/git/python
alias gpython=$HOME/git/python
alias pysh=$HOME/git/python/shell
alias ggas=$HOME/git/google-apps-script/
alias gdspw=$HOME/git/google-apps-script/sheets/dspw
alias gfst=$HOME/git/google-apps-script/sheets/fs-time-dev
alias dot=$HOME/dotfiles/dotfiles
alias gdot=$HOME/dotfiles/dotfiles
alias vdot=$HOME/dotfiles/dotfiles/.vim
alias vico=$HOME/dotfiles/dotfiles/.vim/config
alias bcd=$XDG_CONFIG_HOME/bash/conf.d
alias bfd=$XDG_CONFIG_HOME/bash/functions
alias sfd=$XDG_CONFIG_HOME/shell/functions
alias scd=$XDG_CONFIG_HOME/shell/conf.d
alias rmdir='rm -rf'
alias version='cat /etc/os-release'
alias lookbusy='cat /dev/urandom | hexdump -C | grep --color "ca fe"'
alias mntp='sudo mount -t drvfs P: /mnt/p'
alias ls='ls -h --color=auto --group-directories-first'
alias lsa='ls -ah'
alias la='ls -ah'
alias ll='ls -lh'
alias lla='ls -lah'
alias x=exit
alias q=exit
alias quit=exit
alias che='chmod +x'
alias chr='chmod 755'
alias fp="fzf-tmux --reverse --preview 'cat {} --color=always'"
alias pr='powerline-daemon --replace'
alias l='list'
alias listd='list --debug'
alias listh='list --help'
alias t=todo
alias tp=topydo
alias te="vim $HOME/.tmux.conf && tmux source ~/.tmux.conf && tmux display '~/.tmux.conf sourced'"
alias tl='tmux ls'
alias v=vim
alias n=nvim
alias nv=nvim
alias vvim='command vim'
alias vv='command vim'
alias vet='vim $HOME/dotfiles/dotfiles/env.toml'
alias brc='vim ~/.bashrc'
alias zshc='vim ~/.zshrc'
alias denv='source $def_venv/bin/activate'
alias git=hub
alias grep=grep --color=auto
alias fgrep=fgrep --color=auto
alias egrep=egrep --color=auto
alias vim=$VISUAL
