# Defined in /tmp/fish.KlBeUD/loadtheme.fish @ line 2
function loadtheme --description 'load theme if no pkg manager is being used' --argument target_theme
	set -l plugin_dir $XDG_DATA_HOME/fish_plugins/themes/$target_theme
    if not test -d $plugin_dir
        echo "Cannot find $target_theme in themes directory."
        return 0
    end
    for f in (find $plugin_dir -maxdepth 2 -iname "*.fish")
        source $f
    end
    set -gx FISH_THEME $target_theme
    return 0
end
