# Defined in /tmp/fish.pchRMp/vim.fish @ line 2
function vim --description 'Calls Neovim or Vim based on nvim and availability'
	if string match -- '*.vim' $argv
        command nvim $argv
        return
    end
	if type -qf "$VISUAL"
        command $VISUAL $argv
    else if type -qf "$EDITOR"
        command $EDITOR $argv
    else
        # No VISUAL/EDITOR defined; call vim
        command vim $argv
    end
end
