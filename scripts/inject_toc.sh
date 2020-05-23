#!/usr/bin/env bash
set -euo pipefail

# TODO: refactor to be less gross with the hardcoded paths
sed '/~~~TOC~~~/{
  s/~~~TOC~~~//g
  r _build/toc.md
}' pages/index.md > _build/index.md