_xh() {
    local i cur prev opts cmds
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    cmd=""
    opts=""

    for i in ${COMP_WORDS[@]}
    do
        case "${i}" in
            xh)
                cmd="xh"
                ;;

            *)
                ;;
        esac
    done

    case "${cmd}" in
        xh)
            opts=" -j -f -m -h -b -v -q -S -d -c -F -I -V -s -p -o -A -a  --json --form --multipart --headers --body --verbose --quiet --stream --download --continue --ignore-netrc --offline --check-status --follow --https --ignore-stdin --curl --curl-long --no-auth --no-auth-type --no-bearer --no-body --no-cert --no-cert-key --no-check-status --no-continue --no-curl --no-curl-long --no-default-scheme --no-download --no-follow --no-form --no-headers --no-https --no-ignore-netrc --no-ignore-stdin --no-json --no-max-redirects --no-multipart --no-offline --no-output --no-pretty --no-print --no-proxy --no-quiet --no-stream --no-style --no-timeout --no-verbose --no-verify --help --version --pretty --style --print --output --auth-type --auth --bearer --max-redirects --timeout --proxy --verify --cert --cert-key --default-scheme  <[METHOD] URL> <REQUEST_ITEM>... "
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 1 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in

                --pretty)
                    COMPREPLY=($(compgen -W "all colors format none" -- "${cur}"))
                    return 0
                    ;;
                --style)
                    COMPREPLY=($(compgen -W "auto solarized" -- "${cur}"))
                    return 0
                    ;;
                    -s)
                    COMPREPLY=($(compgen -W "auto solarized" -- "${cur}"))
                    return 0
                    ;;
                --print)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                    -p)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --output)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                    -o)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --auth-type)
                    COMPREPLY=($(compgen -W "basic bearer" -- "${cur}"))
                    return 0
                    ;;
                    -A)
                    COMPREPLY=($(compgen -W "basic bearer" -- "${cur}"))
                    return 0
                    ;;
                --auth)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                    -a)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --bearer)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --max-redirects)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --timeout)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --proxy)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --verify)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --cert-key)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --default-scheme)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;

    esac
}

complete -F _xh -o bashdefault -o default xh
