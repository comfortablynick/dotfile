# Defined in /var/folders/gb/x1313fbd2klb5mss86_gsd1m0000gn/T//fish.8J54HB/argtest.fish @ line 2
function argtest --description 'test of argparse'
	set -l options 'u/url=' 'p/path=' 'c/cond=' 'h/help'
    set -l help_txt "argtest help"
    test -z "$argv" && echo "$help_txt" && return 1
    argparse $options -- $argv

    # Process options
    set -q _flag_help && echo "$help_txt" && return 0
    set -q _flag_url && echo $_flag_url
    set -q _flag_path && echo $_flag_path
    set -q _flag_cond && echo $_flag_cond

    if test (eval $_flag_cond)
        echo "Cond true"
    else
        echo "Cond false"
    end

    if test -n "$argv"
        echo $argv
    end
end
