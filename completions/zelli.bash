_zelli_sessions() {
  local curr_arg
  curr_arg="${COMP_WORDS[COMP_CWORD]}"

  if [[ ${COMP_CWORD} -eq 1 ]]; then
    COMPREPLY=($(compgen -W "$(find ~/.config/zellij/layouts/*.kdl -printf '%f\n' 2>/dev/null | sed 's/\.kdl$//')" -- "$curr_arg"))
  elif [[ ${COMP_CWORD} -eq 2 ]]; then
    COMPREPLY=($(compgen -W "clear" -- "$curr_arg"))
  fi
}

complete -F _zelli_sessions zelli
