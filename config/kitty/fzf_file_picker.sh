#!/usr/bin/env bash

selected=$(fzf --walker file,hidden --height=80% --border)
[ -z "$selected" ] && exit 0

abs_path="$(realpath "$selected")"

# clipboard
printf "%s" "$abs_path" | kitty +kitten clipboard

# send to focused terminal (NO kitty @ ls, NO jq)
kitty @ send-text --match state:focused "$abs_path\n"
