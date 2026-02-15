#!/usr/bin/env bash
# Look through all the TSV vocabulary lists and find any problematic files

shopt -s globstar

err () {
	printf '%s\n' "$2"
	exit "$1"
}

for f in ./res/*.tsv; do
	printf '%s\n' "[INFO] Testing file '$f'..."
	lua ./tools/test-tsv.lua "$f" >/dev/null || err 1 "[WARN] Error in '$f'" 
done
