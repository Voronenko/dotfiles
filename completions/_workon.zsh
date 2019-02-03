#compdef workon

_workon() {
    local curcontext="$curcontext" state line
    typeset -A opt_args

    _arguments '1: :->csi'

    case $state in
    csi)
      _arguments "1: :($(ls -1d $WORKON_HOME/*/ | awk -F "/" "{print \$(NF-1)}"))"
    ;;
    esac
}

_workon "$@"
