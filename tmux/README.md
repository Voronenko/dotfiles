## tmux adopted

set -g @plugin 'eugene-eeo/tmux-badges'


## tmux-badges

Enables you to do fancy badges a-la shields.io in tmux.
Usage example:

```
## tmux.conf
set -g @badge_py     'py'
set -g @badge_py_fg  'default'
set -g @badge_py_bg  'colour25'
set -g @badge_py_fmt '#(pyenv version | cut -f 1 -d " ")'
set -g @badge_py_secondary_fg 'default'
set -g @badge_py_secondary_bg 'colour236'

set -g @badge_awesome 'awesome'
set -g @badge_awesome_fmt 'true'

set -g status-right ' #{badge_py} #{badge_awesome} '
```

![sec(c)](screenshot.png)

### Installation

The recommended way is to use TPM.

```
set -g @plugin 'eugene-eeo/tmux-badges'
```

### Manually

```
$ git clone https://github.com/eugene-eeo/tmux-badges.git ~/clone/path
$ echo 'run-shell ~/clone/path/badges.tmux' >> ~/.tmux.conf
$ tmux source-file ~/.tmux.conf
```
