#!/usr/bin/env bash

# The overlay inherits the parent window's CWD via --cwd=current in kitty.conf
GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")

# Get parent window ID dynamically (second newest window)
PARENT_ID=$(kitty @ ls | jq -r '.[].tabs[].windows[] | .id' | sort -rn | sed -n '2p')

# Create prompt with path
prompt_path=$(basename "$GIT_ROOT")
if [ "$GIT_ROOT" != "$PWD" ]; then
  rel="${PWD#$GIT_ROOT/}"
  prompt_path="$prompt_path/$rel"
fi

# Use fd or find to list files, then fzf for selection
if command -v fd &>/dev/null; then
  selected=$(fd --hidden --exclude '.git' . "$GIT_ROOT" | fzf --prompt="File in $prompt_path > " --height=80% --border)
else
  selected=$(find "$GIT_ROOT" -type f ! -path '*/.git/*' | fzf --prompt="File in $prompt_path > " --height=80% --border)
fi

[ -z "$selected" ] && exit 0

# Compute relative path from git root
relative_path="${selected#$GIT_ROOT/}"

# Format with @ prefix and send to parent window
kitty @ send-text --match="id:$PARENT_ID" "@$relative_path"
