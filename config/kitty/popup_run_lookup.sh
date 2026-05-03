#!/usr/bin/env bash

# The overlay inherits the parent window's CWD via --cwd=current in kitty.conf
GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")

# Get parent window ID dynamically
PARENT_ID=$(kitty @ ls | jq -r '.[].tabs[].windows[] | .id' | sort -rn | sed -n '2p')

# Create prompt with path
prompt_path=$(basename "$GIT_ROOT")
if [ "$GIT_ROOT" != "$PWD" ]; then
  rel="${PWD#$GIT_ROOT/}"
  prompt_path="$prompt_path/$rel"
fi

# List all executable files
selected=$(find "$GIT_ROOT" -type f -executable ! -path '*/.git/*' ! -path '*/node_modules/*' | fzf --prompt="Exec in $prompt_path > " --height=80% --border --query=".ai-files/")

[ -z "$selected" ] && exit 0

# Compute relative path from git root
relative_path="${selected#$GIT_ROOT/}"

# Format with ! prefix and send to parent window
kitty @ send-text --match="id:$PARENT_ID" "!$relative_path"
