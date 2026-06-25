#!/usr/bin/env bash

# === common block start ===
_DEBUG_SENTINEL="${HOME}/.config/kitty/.popup-debug"
_debug_log() {
  [ -f "$_DEBUG_SENTINEL" ] || return 0
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> /tmp/kitty-popup-debug.log
}
_detect_parent_window() {
  kitty @ ls | jq -r '
    [ .[].tabs[]
      | select(.is_focused)
      | .windows[]
      | select(.is_focused | not)
    ]
    | sort_by(.id)
    | reverse
    | .[0].id
  '
}
# === common block end ===

# The overlay inherits the parent window's CWD via --cwd=current in kitty.conf
GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")

# Get parent window ID dynamically
PARENT_ID=$(_detect_parent_window)
_debug_log "PARENT_ID=$PARENT_ID"
[ -f "$_DEBUG_SENTINEL" ] && _debug_log "kitty @ ls: $(kitty @ ls | jq -c '.')"
_debug_log "GIT_ROOT=$GIT_ROOT"

# Create prompt with path
prompt_path=$(basename "$GIT_ROOT")
if [ "$GIT_ROOT" != "$PWD" ]; then
  rel="${PWD#$GIT_ROOT/}"
  prompt_path="$prompt_path/$rel"
fi

# Use fd or find to list files, then fzf for selection
if command -v fd &>/dev/null; then
  selected=$(fd --hidden --no-ignore-vcs --exclude '.git' . "$GIT_ROOT" | fzf --prompt="File in $prompt_path > " --height=80% --border)
else
  selected=$(find "$GIT_ROOT" -type f ! -path '*/.git/*' | fzf --prompt="File in $prompt_path > " --height=80% --border)
fi

[ -z "$selected" ] && { _debug_log "no selection, exiting"; exit 0; }

# Compute relative path from git root
relative_path="${selected#$GIT_ROOT/}"
_debug_log "selected=$selected"
_debug_log "relative_path=$relative_path"

# Format with @ prefix and send to parent window
kitty @ send-text --match="id:$PARENT_ID" "@$relative_path"
