## Example upgrading tmux 2.x=>2.9

### panes
```
set -g pane-border-fg black
set -g pane-active-border-fg brightred
```
to
```
set -g pane-border-style fg=black
set -g pane-active-border-style fg=brightred
```

### messaging

```
set -g message-fg black
set -g message-bg yellow
set -g message-command-fg blue
set -g message-command-bg black
```
to
```
set -g message-style fg=black,bg=yellow
set -g message-command-style fg=blue,bg=yellow
```

### window mode
```
setw -g mode-bg colour6
setw -g mode-fg colour0
```
to
```
setw -g mode-style bg=colour6,fg=colour0
```

### window status

```
setw -g window-status-current-bg colour0
setw -g window-status-current-fg colour11
setw -g window-status-current-attr dim
setw -g window-status-bg green
setw -g window-status-fg black
setw -g window-status-attr reverse
```
to
```
setw -g window-status-current-style bg=colour0,fg=colour11,dim
setw -g window-status-style bg=green,fg=black,reverse
```

### The modes
```
setw -g mode-attr bold
setw -g mode-fg colour196
setw -g mode-bg colour238
```
to
```
setw -g mode-style bg=colour238,fg=colour196,bold
```

### The panes
```
set -g pane-border-bg colour235
set -g pane-border-fg colour238
set -g pane-active-border-bg colour236
set -g pane-active-border-fg colour51
```
to
```
set -g pane-border-style bg=colour235,fg=colour238
set -g pane-active-border-style bg=colour236,fg=colour251
```

### # The statusbar {
```
set -g status-bg colour234
set -g status-fg colour137
set -g status-attr dim
```
to
```
set -g status-style dim,bg=colour234,fg=colour137
```

```
setw -g window-status-current-fg colour81
setw -g window-status-current-bg colour238
setw -g window-status-current-attr bold
```
to
```
setw -g window-status-current-style bg=colour238,fg=colour81,bold
```

```
setw -g window-status-fg colour138
setw -g window-status-bg colour235
setw -g window-status-attr none
```
to
```
setw -g window-status-style bg=colour235,fg=colour138,none
```

```
setw -g window-status-bell-attr bold
setw -g window-status-bell-fg colour255
setw -g window-status-bell-bg colour1
```
to
```
setw -g window-status-bell-style bg=colour1,fg=colour255,bold
```

### The messages

```
set -g message-attr bold
set -g message-fg colour232
set -g message-bg colour166
```
to
```
set -g message-style bg=colour166,fg=colour232,bold
```












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
