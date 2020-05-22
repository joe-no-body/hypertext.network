.ONESHELL:

export SRC_DIR = pages
src = $(wildcard $(SRC_DIR)/*.md)

all: _build/markdown/toc.md

_build/markdown:
	mkdir -p $@

_build/markdown/toc.md: SHELL := bash
_build/markdown/toc.md: $(src) _build/markdown
	bash scripts/toc.sh > $@

clean:
	rm -rf _build