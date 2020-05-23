#!/usr/bin/env bash
set -euo pipefail
shopt -s globstar

source scripts/pages.sh

# generate HTML from markdown
for page in "${pages[@]}"; do
  if [[ "$page" == pages/index.md ]]; then
    continue
  fi
  # change directory
  pageout="site/${page##pages/}"
  # change extension
  pageout="${pageout%%.md}.html"

  pagedir="$(dirname "$pageout")"

  echo "$page -> $pageout (dir: $pagedir)"

  mkdir -p "$pagedir"
  pandoc -s -o "$pageout" "$page"
done

# generate index page with TOC
echo "Generating table of contents"
bash scripts/toc.sh > _build/toc.md
echo "Inserting into index"
bash scripts/inject_toc.sh

echo "Generating index"
pandoc -s -o site/index.html _build/index.md