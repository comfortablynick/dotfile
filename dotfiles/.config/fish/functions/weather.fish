# Defined in - @ line 2
function weather --description 'Display cli output of weather'
	set -l script "$HOME/git/python/shell/weather/weather.py"
    if test -x $script
        python $script
    else if test -e $script
        echo "$script exists but is not executable."
    else
        echo "Cannot find $script"
    end
end