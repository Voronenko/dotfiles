#compdef gouse

_gouse() {
    local curcontext="$curcontext" state line
    typeset -A opt_args

    _arguments '1: :->csi'

    case $state in
    csi)
      _arguments "1: :($(ls -1d ~/.gimme/envs/* | awk -F "/" "{print \$(NF)}"))"
    ;;
    esac
}

_gouse "$@"
