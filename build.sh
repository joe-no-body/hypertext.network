#!/usr/bin/env bash
set -euo pipefail
shopt -s globstar

for page in pages/**/*.md; do
  # change directory
  pageout="site/${page##pages/}"
  # change extension
  pageout="${pageout%%.md}.html"
  pagedir="$(dirname "$pageout")"
  echo "$page -> $pageout (dir: $pagedir)"

  mkdir -p "$pagedir"
  pandoc -s -o "$pageout" "$page"
done