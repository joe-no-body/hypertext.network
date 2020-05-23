#!/usr/bin/env bash
set -euo pipefail
shopt -s globstar

readonly -a pages=(
  pages/**/*.md
)

: "${BASE_PATH:=}"

if [[ -t 2 ]]; then
  readonly blue="$(tput setaf 14)"
  readonly reset="$(tput sgr0)"
else
  readonly blue=
  readonly reset=
fi

info() {
  echo "${blue}*** $*${reset}" >&2
}

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

# get the bare name of a page without the base path and extension
get_page_name() {
  : "${1##pages/}"
  echo "${_%%.md}"
}

build_site() {
  for page in "${pages[@]}"; do
    if [[ "$page" == pages/index.md ]]; then
      continue
    fi
    pageout="docs/$(get_page_name "$page").html"
    pagedir="$(dirname "$pageout")"
    info "$page -> $pageout (dir: $pagedir)"
    # need to ensure the output directory exists or pandoc will fail
    mkdir -p "$pagedir"
    generate_nonindex_page "$pageout" "$page"
  done
}

generate_toc() {
  for page in "${pages[@]}"; do
    if [[ "$page" == pages/index.md ]]; then
      continue
    fi
    page_name="$(get_page_name "$page")"
    echo "[$page_name]($BASE_PATH/$page_name.html)"
    echo
  done
}

# generate index page with TOC
generate_index() {
  info "Generating table of contents for index"
  generate_toc > _build/toc.md

  info "Inserting TOC into index"
  sed '/~~~TOC~~~/{
    s/~~~TOC~~~//g
    r _build/toc.md
  }' pages/index.md > _build/index.md

  info "Generating index"
  generate_page docs/index.html _build/index.md \
    --include-after-body "_build/footer.html"
}

main() {
  mkdir -p _build

  info "Generating header"
  generate_fragment _build/header.html components/header.md

  info "Generating footer"
  generate_fragment _build/footer.html components/footer.md

  info "Generating HTML from markdown"
  build_site

  generate_index

  info "Loading css"
  cp pandoc.css docs/pandoc.css
}
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi