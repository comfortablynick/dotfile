function kill_processes --description 'Kill processes'
	set -l __kp__pid ''

  if contains -- '--tcp' $argv
    set __kp__pid (lsof -Pwni tcp | sed 1d | eval "fzf-tmux -m --header='[kill:tcp]'" | awk '{print $2}')
  else
    set __kp__pid (ps -ef | sed 1d | eval "fzf-tmux -m --header='[kill:process]'" | awk '{print $2}')
  end

  if test "x$__kp__pid" != "x"
    if test "x$argv[1]" != "x"
      echo $__kp__pid | xargs kill $argv[1]
    else
      echo $__kp__pid | xargs kill -9
    end
    kp
  end
end
