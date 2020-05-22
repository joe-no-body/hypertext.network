#!/usr/bin/env bash
# List pages relative to the pages directory.
set -euo pipefail
shopt -s globstar

for page in "$SRC_DIR"/**/*.md; do
  echo "${page##$SRC_DIR/}"
done