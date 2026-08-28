#!/usr/bin/env bash

set -euo pipefail

while getopts "t:" opt; do
	case "$opt" in
		t)
			DEADLINE="$((EPOCHSECONDS + OPTARG))"
			shift
			shift
			;;
		"?")
			>&2 echo "Invalid option"
			exit 1
			;;
	esac
done

until nc -z localhost "$@"; do
	if [[ -n "${DEADLINE-}" && "$DEADLINE" -le "$EPOCHSECONDS" ]]; then
		>&2 echo "Timeout"
		exit 1
	fi
	sleep 1
done
