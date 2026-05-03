#!/usr/bin/env bash

# The overlay inherits the parent window's CWD via --cwd=current in kitty.conf
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")
SKILLS_DIR="$PROJECT_ROOT/.ai-files/skills"

# Get parent window ID dynamically
PARENT_ID=$(kitty @ ls | jq -r '.[].tabs[].windows[] | .id' | sort -rn | sed -n '2p')

# Check if skills directory exists
if [ ! -d "$SKILLS_DIR" ]; then
  kitty @ send-text --match="id:$PARENT_ID" "No .ai-files/skills directory found"
  exit 0
fi

# Build list of skills with descriptions
skills_list=""
while IFS= read -r -d '' skill_dir; do
  skill_name=$(basename "$skill_dir")

  # Try to get description from SKILL.md
  skill_md="$skill_dir/SKILL.md"
  description=""
  if [ -f "$skill_md" ]; then
    description=$(awk '/^---$/{if(n==1)exit; n=1;next} n==1 && /^description:/{print substr($0,14); exit}' "$skill_md" 2>/dev/null || echo "")
    # Remove quotes and trim
    description="${description%\"}"
    description="${description#\"}"
  fi

  [ -z "$description" ] && description="See SKILL.md for details"

  # Truncate description if too long
  if [ ${#description} -gt 60 ]; then
    description="${description:0:60}…"
  fi

  # Use tab as delimiter instead of pipe
  skills_list="$skills_list$skill_name\t$description\n"
done < <(find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d -not -name ".*" -print0 2>/dev/null)

[ -z "$skills_list" ] && {
  kitty @ send-text --match="id:$PARENT_ID" "No skills found in .ai-files/skills"
  exit 0
}

# Use fzf with multi-selection
selection=$(echo -e "$skills_list" | fzf \
  --prompt="Skills > " \
  --height=80% \
  --border \
  --multi \
  --delimiter=$'\t' \
  --with-nth=1 \
  --preview="echo {2}" \
  --preview-window=down:3:wrap \
  --header="[TAB] multi-select | [ENTER] confirm" \
  --bind='enter:accept')

[ -z "$selection" ] && exit 0

# Extract skill names from selection and format each with ** **
formatted_skills=""
while IFS=$'\t' read -r name _; do
  # Remove fzf selection marker (> ) if present
  clean_name="${name#\> }"
  [ -n "$clean_name" ] && formatted_skills="$formatted_skills**$clean_name**,"
done <<< "$selection"

# Remove trailing comma
formatted_skills="${formatted_skills%,}"

# Format output and send to parent window
kitty @ send-text --match="id:$PARENT_ID" "Use $formatted_skills skills"
