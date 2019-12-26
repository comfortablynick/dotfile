#!/usr/bin/env bash
# Helpful bash scripts; loaded by .bashrc
# For: funcs available at all times (not loaded in $PATH)

# Reset the terminal and source .bashrc
reload() {
    reset
    export DEBUG_MODE=false
    source ${HOME}/.bashrc
}

# Reset and print elapsed time for debugging
brel() {
    reset
    if [ "$1" == "d" ]; then
        export DEBUG_MODE=true
    else
        export DEBUG_MODE=false
    fi
    time . "${HOME}/.bashrc"
}

# Easily print timestamp
timestamp() {
    date +"%T"
}

# is_ssh :: Return true if in SSH session
is_ssh() {
    if [[ -n $SSH_CLIENT ]] || [[ -n $SSH_TTY ]]; then
        return 0
    else
        return 1
    fi
}

# is_mosh :: Return true if in Mosh session
is_mosh() {
    local tmux_current_session tmux_client_id pid mosh_found
    if [[ -n $TMUX ]]; then
        # current shell is under tmux
        tmux_current_session=$(tmux display-message -p '#S')
        tmux_client_id=$(tmux list-clients -t "${tmux_current_session}" -F '#{client_pid}')
        pid="$tmux_client_id"
    else
        pid="$$"
    fi
    mosh_found=$(pstree -ps $pid | grep mosh-server) # or empty if not found
    if [[ -z $mosh_found ]]; then
        return 1 # exit code 1: not mosh
    fi
    return 0 # exit code 0: is mosh
}

# wrapper for cd builtin
# show directory contents if not $HOME
cd() {
    builtin cd "$@" && {
        if [[ $PWD != "$HOME" ]] || [[ $LS_AFTER_CD -eq 1 ]]; then
            ls --group-directories-first
        fi
    }
}

# _pyenv_virtualenv_hook() {
#     local ret=$?
#     if [ -n "$VIRTUAL_ENV" ]; then
#         eval "$(pyenv sh-activate --quiet || pyenv sh-deactivate --quiet || true)" || true
#     else
#         eval "$(pyenv sh-activate --quiet || true)" || true
#     fi
#     return $ret
# }
# if [[ -n $(command -v pyenv 2>/dev/null) ]] && ! [[ "$PROMPT_COMMAND" =~ _pyenv_virtualenv_hook ]]; then
#     PROMPT_COMMAND="_pyenv_virtualenv_hook;$PROMPT_COMMAND"
# fi

# pyenv() {
#     local command
#     command="${1:-}"
#     if [ "$#" -gt 0 ]; then
#         shift
#     fi

#     case "$command" in
#     activate | deactivate | rehash | shell)
#         eval "$(pyenv "sh-$command" "$@")"
#         ;;
#     *)
#         command pyenv "$command" "$@"
#         ;;
#     esac
# }

# NVM lazy loading
#
# NVM takes on average half of a second to load, which is more than whole prezto takes to load.
# This can be noticed when you open a new shell.
# To avoid this, we are creating placeholder function
# for nvm, node, and all the node packages previously installed in the system
# to only load nvm when it is needed.
#
# This code is based on the scripts:
# * https://www.reddit.com/r/node/comments/4tg5jg/lazy_load_nvm_for_faster_shell_start/d5ib9fs
# * http://broken-by.me/lazy-load-nvm/
# * https://github.com/creationix/nvm/issues/781#issuecomment-236350067
#

NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

# # Skip adding binaries if there is no node version installed yet
# if [ -d $NVM_DIR/versions/node ]; then
#     NODE_GLOBALS=($(find $NVM_DIR/versions/node -maxdepth 3 \( -type l -o -type f \) -wholename '*/bin/*' | xargs -n1 basename | sort | uniq))
# fi
# NODE_GLOBALS+=("nvm")

# load_nvm() {
#     # Unset placeholder functions
#     for cmd in "${NODE_GLOBALS[@]}"; do unset -f ${cmd} &>/dev/null; done

#     # Load NVM
#     [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

#     # (Optional) Set the version of node to use from ~/.nvmrc if available
#     nvm use 2>/dev/null 1>&2 || true

#     # Do not reload nvm again
#     export NVM_LOADED=1
# }

# for cmd in "${NODE_GLOBALS[@]}"; do
#     # Skip defining the function if the binary is already in the PATH
#     if ! which ${cmd} &>/dev/null; then
#         eval "${cmd}() { unset -f ${cmd} &>/dev/null; [ -z \${NVM_LOADED+x} ] && load_nvm; ${cmd} \$@; }"
#     fi
# done
