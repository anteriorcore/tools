#!/usr/bin/env bash

set -euo pipefail

# Grep the output from a nix build --dry-run command and only print the
# derivations which actually need _building_.
sed -ne '/will be built:$/ {
  # label
  :b
  # next line
  n
  # If the line is indented, it is a store path
  /^ /{
	# Print it
	p
	# goto label b
	bb
  }
}' | sed -e 's/$/^*/'
