# Source pyenv scripts
if status is-interactive
and test -n (type -f pyenv 2>/dev/null)
    source (pyenv init -|psub)
    source (pyenv virtualenv-init -|psub)
end
