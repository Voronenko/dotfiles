# git-wt Completions

This directory contains shell completion scripts for `git-wt`.

## Installation

### Bash

Add the following to your `~/.bashrc` or `~/.bash_profile`:

```bash
# git-wt completion
source /path/to/dotfiles/completions/git-wt.bash
```

Or, for system-wide installation:

```bash
sudo cp completions/git-wt.bash /etc/bash_completion.d/git-wt
```

### Zsh

Add the following to your `~/.zshrc`:

```bash
# git-wt completion
fpath=(/path/to/dotfiles/completions $fpath)
autoload -U compinit && compinit
```

Or, for system-wide installation:

```bash
sudo cp completions/git-wt.zsh /usr/share/zsh/vendor-completions/_git-wt
```

### Using with dotfiles

If you're using this as part of your dotfiles, you can add to your shell config:

**Bash (~/.bashrc):**
```bash
# git-wt completion
if [[ -f "$HOME/dotfiles/completions/git-wt.bash" ]]; then
    source "$HOME/dotfiles/completions/git-wt.bash"
fi
```

**Zsh (~/.zshrc):**
```bash
# git-wt completion
if [[ -d "$HOME/dotfiles/completions" ]]; then
    fpath=("$HOME/dotfiles/completions" $fpath)
    autoload -U compinit && compinit
fi
```

## Usage

After installing, restart your shell or source your shell config file. Then you can use tab completion:

```bash
git-wt <TAB>          # Show all subcommands
git-wt add <TAB>        # Show add options
git-wt add -b <TAB>     # Show available branches
git-wt sync <TAB>        # Show available worktrees
git-wt <worktree-name>   # Show available worktrees for switching
```

## Features

- **Subcommand completion**: Completes all git-wt subcommands (add, list, -i, sync, -, help)
- **Option completion**: Completes options for the `add` subcommand (-f, -b, -B, --force, --help)
- **Branch completion**: Completes branch names when using `-b` or `-B` options
- **Worktree completion**: Completes worktree names/paths for switching and syncing
- **Directory completion**: Completes directory names in worktree root when creating new worktrees
