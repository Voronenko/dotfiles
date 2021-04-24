#! /bin/sh

paster() {
  while read email; do
    [ -z "$email" ] || echo "$1" "$email"
  done
}

grouper() {
  IFS="<"
  read x cur_name email
  canonical_email="<"${email}
  cur_emails=""
  while read x name email; do
    if [ "$name" = "$cur_name" ]; then
      cur_emails="$cur_emails <${email}"
    else
      echo "$cur_emails"|tr ' ' '\n'|paster "$canonical_email"
      cur_name="$name"
      canonical_email="<"${email}
      cur_emails=""
    fi
  done
  echo "$cur_emails"|tr ' ' '\n'|paster "$canonical_email"
}

root_dir="$(git rev-parse --show-cdup)"; root_dir="${root_dir:-.}"
cd "$root_dir"
git shortlog -s -e|tr '\t' '<'|sort -t '<' -k 2,2 -k 1,1nr|grouper|tee ${1:--a} .mailmap
git add .mailmap
