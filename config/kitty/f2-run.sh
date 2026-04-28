#!/usr/bin/env bash
set -euo pipefail

MENU_FILE="$HOME/.config/kitty/commands.yaml"
ENTRY_NAME="$1"

# Extract commands
mapfile -t CMDS < <(
  yq -r "
    .bookmarks[]
    | select(.name == \"$ENTRY_NAME\")
    | .cmds[]
  " "$MENU_FILE"
)

[ "${#CMDS[@]}" -eq 0 ] && {
  echo "No commands found"
  exit 1
}

echo "▶ Running: $ENTRY_NAME"
echo "----------------------------------------"

# Run in interactive shell so cd works
(
  set -e
  for cmd in "${CMDS[@]}"; do
    echo "+ $cmd"
    eval "$cmd"
  done
)

echo
read -n1 -r -p "✔ Done. Press any key to close…"
