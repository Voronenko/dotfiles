#!/usr/bin/env bash
set -euo pipefail

MENU_FILE="$HOME/dotfiles/config/zellij/zellij_bookmarks.yaml"

# Build menu: name | labels | desc
choice=$(
  yq -r '
    .bookmarks[] |
    [.name, (.labels // [] | join(",")), (.desc // "")] |
    @tsv
  ' "$MENU_FILE" |
  column -ts $'\t' |
  fzf \
    --prompt="F2 > " \
    --with-nth=1,2,3 \
    --delimiter='\t' \
    --preview '
      echo "Name: {1}"
      echo "Labels: {2}"
      echo
      echo "{3}"
    '
)

[ -z "$choice" ] && exit 0

name=$(awk -F'\t' '{print $1}' <<< "$choice")

exec bash "$HOME/dotfiles/config/kitty/f2-run.sh" "$name"
