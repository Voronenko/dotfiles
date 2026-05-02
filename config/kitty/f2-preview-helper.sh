#!/usr/bin/env bash
# Helper script to show commands for fzf preview

NAME="$1"
MENU_FILE="$HOME/dotfiles/config/zellij/zellij_bookmarks.yaml"

echo "Name: $NAME"
echo
echo "Commands:"
yq -r ".bookmarks[] | select(.name == \"$NAME\") | .cmds[] | \"- \" + ." "$MENU_FILE" 2>/dev/null || echo "No commands found"
