#!/usr/bin/env bash

# Return if not Windows
[ ${OS_NAME} != "Windows" ] && return;

# Debug
[ ${DEBUG} == true ] && echo "Using .bash_windows";

# Git
GIT_DIR="${HOME}/Git"
alias gpython='cd ${GIT_DIR}/python'
alias ggas='cd ${GIT_DIR}/google-apps-script/sheets'
alias gcp='cd ${GIT_DIR}/google-apps-script/sheets/convention-personnel'
alias gcpr='cd ${GIT_DIR}/google-apps-script/sheets/convention-personnel-reports'
alias gdspw='cd ${GIT_DIR}/google-apps-script/sheets/dspw'
alias gfst='cd ${GIT_DIR}/google-apps-script/sheets/fs-time'

# Python Venv 
VENV_DIR="${HOME}/.pyenv/Scripts/activate"
alias pyenv="source ${VENV_DIR}"

# Activate venv by default
source ${VENV_DIR}

# Terminal colors for LS
eval "$(dircolors -b ${HOME}/.dircolors)"

return;
# Warnings
unset _warning_found
for _warning_prefix in '' ${MINGW_PREFIX}; do
    for _warning_file in ${_warning_prefix}/etc/profile.d/*.warning{.once,}; do
        test -f "${_warning_file}" || continue
        _warning="$(command sed 's/^/\t\t/' "${_warning_file}" 2>/dev/null)"
        if test -n "${_warning}"; then
            if test -z "${_warning_found}"; then
                _warning_found='true'
                echo
            fi
            if test -t 1
                then printf "\t\e[1;33mwarning:\e[0m\n${_warning}\n\n"
                else printf "\twarning:\n${_warning}\n\n"
            fi
        fi
        [[ "${_warning_file}" = *.once ]] && rm -f "${_warning_file}"
    done
done
unset _warning_found
unset _warning_prefix
unset _warning_file
unset _warning

# If MSYS2_PS1 is set, use that as default PS1;
# if a PS1 is already set and exported, use that;
# otherwise set a default prompt
# of user@host, MSYSTEM variable, and current_directory
[[ -n "${MSYS2_PS1}" ]] && export PS1="${MSYS2_PS1}"
# if we have the "High Mandatory Level" group, it means we're elevated
#if [[ -n "$(command -v getent)" ]] && id -G | grep -q "$(getent -w group 'S-1-16-12288' | cut -d: -f2)"
#  then _ps1_symbol='\[\e[1m\]#\[\e[0m\]'
#  else _ps1_symbol='\$'
#fi
[[ $(declare -p PS1 2>/dev/null | cut -c 1-11) = 'declare -x ' ]] || \
  export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[35m\]$MSYSTEM\[\e[0m\] \[\e[33m\]\w\[\e[0m\]\n'"${_ps1_symbol}"' '
unset _ps1_symbol

# Fixup git-bash in non login env
shopt -q login_shell || . /etc/profile.d/git-prompt.sh

# Fixup git-bash in non login env
shopt -q login_shell || . /etc/profile.d/git-prompt.sh