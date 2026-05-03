#!/usr/bin/env bash

MENU_FILE="$HOME/dotfiles/config/zellij/zellij_bookmarks.yaml"

# Get parent window ID dynamically (second newest window, excluding this overlay)
PARENT_ID=$(kitty @ ls | jq -r '.[].tabs[].windows[] | .id' | sort -rn | sed -n '2p')

# Build menu: name | desc (using | as delimiter)
choice=$(
  yq -r '.bookmarks[] | .name + "|" + (.desc // "")' "$MENU_FILE" |
  fzf --prompt="F2 > " --height=80% --border \
      --delimiter='|' \
      --with-nth=1 \
      --preview="$HOME/dotfiles/config/kitty/f2-preview-helper.sh {1}" \
      --preview-window=down:10:wrap
)

[ -z "$choice" ] && exit 0

name=$(echo "$choice" | cut -d'|' -f1)

# Extract commands for the selected bookmark
mapfile -t CMDS < <(
  yq -r ".bookmarks[] | select(.name == \"$name\") | .cmds[]" "$MENU_FILE"
)

[ "${#CMDS[@]}" -eq 0 ] && {
  echo "No commands found for: $name"
  exit 1
}

# Send commands to the parent window using explicit ID
for cmd in "${CMDS[@]}"; do
  kitty @ send-text --match="id:$PARENT_ID" "$cmd"$'\n'
done
