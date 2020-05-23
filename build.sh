#!/usr/bin/env bash
set -euo pipefail
shopt -s globstar

readonly -a pages=(
  pages/**/*.md
)

: "${BASE_PATH:=}"

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
    --include-in-header=components/header-includes.html \
    --template template.html
}

generate_nonindex_page() {
  generate_page "$@" \
    --title-prefix="hypertext.network" \
    --include-before-body "_build/header.html" \
    --include-after-body "_build/footer.html"
}

mkdir -p _build

echo "Generating header"
generate_fragment _build/header.html components/header.md

echo "Generating footer"
generate_fragment _build/footer.html components/footer.md

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

for page in "${pages[@]}"; do
  if [[ "$page" == pages/index.md ]]; then
    continue
  fi
  page_name="${page##pages/}"
  page_name="${page_name%%.md}"
  echo "[$page_name]($BASE_PATH/$page_name.html)"
  echo
done > _build/toc.md

echo "Inserting into index"
sed '/~~~TOC~~~/{
  s/~~~TOC~~~//g
  r _build/toc.md
}' pages/index.md > _build/index.md

echo "Generating index"
generate_page docs/index.html _build/index.md \
  --include-after-body "_build/footer.html"

echo "Loading css"
cp pandoc.css docs/pandoc.css