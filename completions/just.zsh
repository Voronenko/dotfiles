_justfile_comp() {
  if [[ -f justfile ]]; then
    local -a recipes
    recipes=(${(f)"$(just --summary | sed 's/:.*//')"})
    _describe 'just recipes' recipes
  fi
}

compdef _justfile_comp just
