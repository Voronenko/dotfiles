#compdef toggl

_toggl-commands() {
  local -a commands

  commands=(
    'add:creates a completed time entry'
    'clients:lists all clients'
    'continue:restarts the last entry'
    'ls:list recent time entries'
    'now:print what you''re working on now'
    'workspaces:lists all workspaces'
    'projects:lists all projects'
    'rm:delete a time entry by id'
    'start:starts a new entry'
    'stop:stops the current entry'
    'www:visits toggl.com'
  )

  _arguments -s : $nul_args && ret=0
  _describe -t commands 'toggl command' commands && ret=0
}

_toggl() {
  local -a nul_args
  nul_args=(
    '(-h --help)'{-h,--help}'[show help message and exit.]'
    '(-q --quiet)'{-q,--quiet}'[don''t print anything]'
    '(-v --verbose)'{-v,--verbose}'[print additional info]'
    '(-d --debug)'{-d,--debug}'[print debugging output]'
  )

  local curcontext=$curcontext ret=1

  if ((CURRENT == 2)); then
    _toggl-commands
  else
    shift words
    (( CURRENT -- ))
    curcontext="${curcontext%:*:*}:toggl-$words[1]:"
    _call_function ret _toggl-command
  fi
}

_toggl "$@"

# Local Variables:
# mode: Shell-Script
# sh-indentation: 2
# indent-tabs-mode: nil
# sh-basic-offset: 2
# End:
# vim: ft=zsh sw=2 ts=2 et
