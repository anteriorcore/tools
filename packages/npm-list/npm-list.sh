#!/usr/bin/env bash

set -euo pipefail

list-local-deps-denorm() {
  if [[ ! -f package.json ]]; then
    >&2 echo "No package.json found in $PWD, cannot list dependencies."
    >&2 echo
    >&2 echo "Are you sure this is a node.js project?"
    exit 1
  fi
  <package.json jq -r '(.dependencies // {}) * (.devDependencies // {}) | .[]' |
    sed -n -e 's/^file://p' |
    while read -r d; do
      (
        cd "$d"
        list-local-deps-denorm
        pwd
      )
    done
}

cmd-list-local-deps() { # list all local NPM dependencies for this project
  (
    ${1+cd "$1"}
    list-local-deps-denorm | awk '!x[$0]++'
  )
}

cmd-list-projects() { # list all NPM projects in this repo
  # ripgrep respects .gitignore
  rg -0 --files -g package-lock.json | while IFS= read -r -d $'\0' f; do
    d="${f%/*}"
    cmd-list-local-deps "$d"
    (cd "$d" && pwd)
  done | awk '!x[$0]++'
}

cmd-help() {
  cat <<'EOF'
Generic NPM project finding utilities.  Help manage a monorepo with multiple NPM
projects some of which depend on others, transitively.

Usage:

EOF
  sed -ne 's/^cmd-\([^(]*\)()[^#]*/- npm-list \1  /p' "${BASH_SOURCE[0]}"
}

cmd=""
if [[ "$#" -gt 0 ]]; then
  cmd="$1"
  shift
fi

f="cmd-$cmd"
if ! type "$f" &>/dev/null; then
  cmd-help
  exit 1
fi

cmd-"$cmd" "$@"
