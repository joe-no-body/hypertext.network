#!/usr/bin/env bash
set -euo pipefail
shopt -s globstar

readonly -a pages=(
  pages/**/*.md
)