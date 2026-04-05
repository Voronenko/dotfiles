#!/usr/bin/env bash
# git-wt bash completion

_git_wt() {
    local cur prev words cword
    _init_completion || return

    local subcommands="add list -i sync - help"

    case "${prev}" in
        add)
            COMPREPLY=($(compgen -W "-f -b -B --force --help" -- "${cur}"))
            return
            ;;
        -b|-B)
            # Complete branch names
            local branches
            branches=$(git branch -a 2>/dev/null | sed 's/^[* ] //; s|remotes/origin/||' | grep -v "^HEAD$" | sort -u)
            COMPREPLY=($(compgen -W "${branches}" -- "${cur}"))
            return
            ;;
        sync)
            # Complete worktree paths
            local worktrees
            worktrees=$(git worktree list --porcelain 2>/dev/null | awk '/^worktree / {print $2}')
            COMPREPLY=($(compgen -W "${worktrees}" -- "${cur}"))
            return
            ;;
    esac

    # If we're completing the first argument (subcommand)
    if [[ ${cword} -eq 1 ]]; then
        COMPREPLY=($(compgen -W "${subcommands}" -- "${cur}"))
        return
    fi

    # If we're completing after 'add' and not an option
    if [[ ${words[1]} == "add" ]] && [[ ${cur} != -* ]]; then
        # Check if previous word was -b or -B
        case "${prev}" in
            -b|-B)
                # Already handled above
                return
                ;;
        esac

        # Complete worktree names (directories in worktree root)
        local repo_root worktree_root
        if repo_root=$(git rev-parse --show-toplevel 2>/dev/null); then
            local repo_dir_name parent_dir parent_dir_name
            repo_dir_name=$(basename "$repo_root")
            parent_dir=$(dirname "$repo_root")
            parent_dir_name=$(basename "$parent_dir")

            if [[ "$repo_dir_name" == "$parent_dir_name" ]]; then
                worktree_root="$parent_dir"
            fi

            if [[ -n "$worktree_root" ]]; then
                local all_dirs
                all_dirs=$(ls -1 "$worktree_root" 2>/dev/null)
                COMPREPLY=($(compgen -W "${all_dirs}" -- "${cur}"))
            fi
        fi
        return
    fi

    # Complete options for add subcommand
    if [[ ${words[1]} == "add" ]]; then
        COMPREPLY=($(compgen -W "-f -b -B --force --help" -- "${cur}"))
        return
    fi
}

complete -F _git_wt git-wt
