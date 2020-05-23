#!/usr/bin/env bash
set -euo pipefail
shopt -s globstar

source scripts/pages.sh

# generate HTML from markdown
for page in "${pages[@]}"; do
  # change directory
  pageout="site/${page##pages/}"
  # change extension
  pageout="${pageout%%.md}.html"

  pagedir="$(dirname "$pageout")"

  echo "$page -> $pageout (dir: $pagedir)"

  mkdir -p "$pagedir"
  pandoc -s -o "$pageout" "$page"
done
