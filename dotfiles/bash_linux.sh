#!/usr/bin/env bash
# Return if not Linux
[ ${OS_NAME} != "Linux" ] && return;

# Source colors from file 
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# ALIASES -----------------------------------------------------

# Git
alias gpython='cd ~/git/python'
alias ggas='cd ~/git/google-apps-script/sheets'
alias gfst='cd ~/git/google-apps-script/sheets/fs-time'
alias gcp='cd ~/git/google-apps-script/sheets/convention-personnel'
alias gcpr='cd ~/git/google-apps-script/sheets/convention-personnel-reports'
alias gdspw='cd ~/git/google-apps-script/sheets/dspw'
alias gdspwe='cd ~/git/google-apps-script/sheets/dspw-email'
alias gdot='cd ~/dotfiles'

alias xo='xonsh'

# PYTHON ------------------------------------------------------
# Virtual Env
export VENV_DIR=${HOME}/.env
alias denv='source ${VENV_DIR}/dev/bin/activate'
source "${VENV_DIR}/dev/bin/activate" # Activate by default

# SYSTEM ------------------------------------------------------
export NVM_DIR="$HOME/.nvm"

# Try to load nvm on demand
lnvm() {
    # Load nvm and nvm bash completions	
    [ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"
    [ -s "${NVM_DIR}/bash_completion" ] && \. "${NVM_DIR}/bash_completion"
}

# Prefer neovim to vim, if installed
if [ -x /usr/bin/nvim ]; then
    alias vim='nvim'
    alias vvim='vim'
fi

