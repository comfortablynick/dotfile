# Start tmux session for interactive shells
if status is-interactive
    set -Ux MOSH_CONNECTION 0
    # Detect whether we're in mosh or not
    # if pgrep -x mosh-server >/dev/null
    #     set MOSH_CONNECTION 1
    # end
    set -gx SEP ''
    set -gx SUB '|'
    set -gx RSEP ''
    set -gx RSUB '|'
    if type -qf tmux; and test -z "$TMUX"; and not set -q no_tmux_login
        begin
            if not set -q no_tmux_next_login
                set -l session_name def
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