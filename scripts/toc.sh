#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n'

: "${BASE_PATH:=}"

for page in $(./scripts/list-pages.sh); do
  echo "[$page]($BASE_PATH/$page)"
done