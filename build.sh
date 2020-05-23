#!/usr/bin/env bash
set -euo pipefail
shopt -s globstar

source scripts/pages.sh

generate_fragment() {
  local out="$1"
  local in="$2"
  shift 2
  pandoc --lua-filter=rewrite-urls.lua "$@" -o "$out" "$in"
}

generate_page() {
  local out="$1"
  local in="$2"
  shift 2
  generate_fragment "$out" "$in" "$@" -s \
    --css /pandoc.css \
    --template template.html
}

generate_nonindex_page() {
  generate_page "$@" \
    --title-prefix="hypertext.network" \
    --include-before-body "_build/header.html"
}

echo "Generating header"
generate_fragment _build/header.html components/header.md

echo "Generating HTML from markdown"
for page in "${pages[@]}"; do
  if [[ "$page" == pages/index.md ]]; then
    continue
  fi
  # change directory
  pageout="docs/${page##pages/}"
  # change extension
  pageout="${pageout%%.md}.html"

  pagedir="$(dirname "$pageout")"

  echo "$page -> $pageout (dir: $pagedir)"

  mkdir -p "$pagedir"
  generate_nonindex_page "$pageout" "$page"
done

# generate index page with TOC
echo "Generating table of contents"
bash scripts/toc.sh > _build/toc.md
echo "Inserting into index"
bash scripts/inject_toc.sh

echo "Generating index"
generate_page docs/index.html _build/index.md

echo "Loading css"
cp pandoc.css docs/pandoc.css