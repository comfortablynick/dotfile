# Start tmux session for interactive shells
if status is-interactive
    set -gx SEP ''
    set -gx SUB '|'
    set -gx RSEP ''
    set -gx RSUB '|'
    if test -n (type -f tmux 2>/dev/null)
        and test -z "$TMUX"
        and not set -q no_tmux_login
        begin
            if not set -q no_tmux_next_login
                set -l session_name 'def'
                exec tmux -2 new-session -A -s "$session_name"
            else
                set -e no_tmux_next_login
                set_color yellow
                echo "Note: 'no_tmux_next_login' flag was set for this login."
                echo "TMUX will be used on next login unless flag is reset."
                echo ""
                set_color normal
            end
        end
    end
end