#!/usr/bin/env bash
set -euo pipefail

: "${IN=pages/index.md}"
: "${OUT=_build/index.md}"
: "${TOC=_build/toc.md}"

# TODO: refactor to be less gross with the hardcoded paths
sed "/~~~TOC~~~/{
  s/~~~TOC~~~//g
  r $TOC
}" "$IN" > "$OUT"