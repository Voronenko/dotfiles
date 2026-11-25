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

selected=$(fzf --walker file,hidden --height=80% --border)
[ -z "$selected" ] && exit 0

abs_path="$(realpath "$selected")"
_debug_log "selected abs_path=$abs_path"

# clipboard
printf "%s" "$abs_path" | kitty +kitten clipboard

# send to parent window (overlay is itself focused while this runs)
PARENT_ID=$(_detect_parent_window)
kitty @ send-text --match="id:$PARENT_ID" "$abs_path"
