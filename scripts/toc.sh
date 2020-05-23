#!/usr/bin/env bash
set -euo pipefail

source scripts/pages.sh

: "${BASE_PATH:=}"

for page in "${pages[@]}"; do
  if [[ "$page" == pages/index.md ]]; then
    continue
  fi
  page_name="${page##pages/}"
  page_name="${page_name%%.md}"
  echo "[$page_name]($BASE_PATH/$page_name.html)"
  echo
done
