# Defined in /var/folders/gb/x1313fbd2klb5mss86_gsd1m0000gn/T//fish.N6XLrs/git_branch_name.fish @ line 2
function git_branch_name --description 'Get the name of the current Git branch, tag or sha1'
	set -l branch_name (command git symbolic-ref --short HEAD ^/dev/null)

    if test -z "$branch_name"
        set -l tag_name (command git describe --tags --exact-match HEAD ^ /dev/null)

        if test -z "$tag_name"
            command git rev-parse --short HEAD ^ /dev/null
        else
            printf "%s\n" "$tag_name"
        end
    else
        printf "%s\n" "$branch_name"
    end
end
