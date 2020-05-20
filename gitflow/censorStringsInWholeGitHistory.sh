#!/bin/bash
#arguments are strings to censore

for string in "$@"
do
  echo ""
  echo "================ Censoring string "$string": ================"
  ~/dotfiles/gitflow/replaceStringInWholeGitHistory.sh "$string" "********"
done

echo "When done - git push <remote> -f --all"
