#! /bin/zsh

fzy-file-widget() {
    emulate -L zsh
    zle -I
    local cmd="$(eval "$FZY_DEFAULT_COMMAND" | fzy | read file && echo $file)"
    if [[ -n $cmd ]]; then
        LBUFFER="${LBUFFER}$EDITOR $cmd"
    fi
    zle reset-prompt
}
zle -N fzy-file-widget
