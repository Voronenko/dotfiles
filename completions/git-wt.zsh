#compdef git-wt
# git-wt zsh completion

_git_wt() {
    local -a commands
    commands=(
        'add:Add a new worktree interactively'
        'list:List all worktrees'
        '-i:Interactively select a worktree using fzf'
        'sync:Sync untracked files from main worktree to secondary worktree'
        '-:Go to main worktree'
        'help:Show this help'
    )

    if (( CURRENT == 2 )); then
        _describe -t commands 'git-wt commands' commands
        return
    fi

    local curcontext="$curcontext" state state_descr line
    typeset -A opt_args

    case $words[2] in
        add)
            _arguments -C \
                {-f,--force}'[checkout branch even if already checked out in other worktree]' \
                {-b,}'[create a new branch]:branch:->branches' \
                {-B,}'[create or reset a branch]:branch:->branches' \
                '--help[show this help]' \
                '*:worktree name:->worktrees'

            case $state in
                branches)
                    local branches
                    branches=$(git branch -a 2>/dev/null | sed 's/^[* ] //; s|remotes/origin/||' | grep -v "^HEAD$" | sort -u)
                    _values 'branches' ${(f)branches}
                    ;;
                worktrees)
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
                            local dirs
                            dirs=($worktree_root/*(N:t))
                            _values 'worktree name' $dirs
                        fi
                    fi
                    ;;
            esac
            ;;
        sync)
            local worktrees
            worktrees=$(git worktree list --porcelain 2>/dev/null | awk '/^worktree / {print $2}')
            _values 'worktree path' ${(f)worktrees}
            ;;
        *)
            # Complete worktree names for switching
            local worktrees
            worktrees=$(git worktree list --porcelain 2>/dev/null | awk '/^worktree / {print $2}' | xargs -I{} basename {})
            _values 'worktree name' ${(f)worktrees}
            ;;
    esac
}

_git_wt "$@"
