#!/usr/bin/env bash

export OUT=_build/readme.md
export TOC=_build/readme-toc.md
export BASE_PATH="/pages"
export TOC_SUFFIX=.md

echo "Generating readme table of contents"
bash scripts/toc.sh > _build/readme-toc.md
echo "Inserting into index"
bash scripts/inject_toc.sh

echo "Generating readme"
cat _build/readme.md components/footer.md > README.md