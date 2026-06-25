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

MENU_FILE="$HOME/dotfiles/config/zellij/zellij_bookmarks.yaml"

# Get parent window ID dynamically
PARENT_ID=$(_detect_parent_window)
_debug_log "PARENT_ID=$PARENT_ID"
[ -f "$_DEBUG_SENTINEL" ] && _debug_log "kitty @ ls: $(kitty @ ls | jq -c '.')"
_debug_log "MENU_FILE=$MENU_FILE"

# Build menu: name | desc (using | as delimiter)
choice=$(
  yq -r '.bookmarks[] | .name + "|" + (.desc // "")' "$MENU_FILE" |
  fzf --prompt="F2 > " --height=80% --border \
      --delimiter='|' \
      --with-nth=1 \
      --preview="$HOME/dotfiles/config/kitty/f2-preview-helper.sh {1}" \
      --preview-window=down:10:wrap
)

[ -z "$choice" ] && { _debug_log "no choice, exiting"; exit 0; }

name=$(echo "$choice" | cut -d'|' -f1)
_debug_log "choice=$choice"
_debug_log "name=$name"

# Extract commands for the selected bookmark
mapfile -t CMDS < <(
  yq -r ".bookmarks[] | select(.name == \"$name\") | .cmds[]" "$MENU_FILE"
)

[ "${#CMDS[@]}" -eq 0 ] && {
  _debug_log "no commands found for name=$name"
  echo "No commands found for: $name"
  exit 1
}

_debug_log "commands: ${CMDS[*]}"

# Send commands to the parent window using explicit ID
for cmd in "${CMDS[@]}"; do
  _debug_log "sending: $cmd"
  kitty @ send-text --match="id:$PARENT_ID" "$cmd"$'\n'
done
