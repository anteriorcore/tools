#!/usr/bin/env bash

set -euo pipefail

# Like ‘nix flake check’, but ignores any checks which are available on a binary
# cache.  Default nix flake check will download those to the local store.  On CI
# you don’t need that.


# shellcheck disable=SC2016
nix-build --dry-run --expr '(builtins.getFlake "git+file://${toString ./.}").checks.${builtins.currentSystem}' 2>&1 | \
	tee /dev/stderr | \
	nix-grep-to-build | \
	xargs -r nix build --no-link --print-build-logs --keep-going
