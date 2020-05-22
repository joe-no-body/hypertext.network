.ONESHELL:

export SRC_DIR = pages
export HTML_DIR = site
src = $(shell find $(SRC_DIR)/ -type f -name '*.md')
src_dirs = $(shell find $(SRC_DIR)/ -type d)
html = $(patsubst $(SRC_DIR)/%.md,$(HTML_DIR)/%.html,$(src))
html_dirs = $(patsubst $(SRC_DIR)/,$(HTML_DIR)/,$(src_dirs))

all: html_dirs $(html)

.PHONY: html_dirs
html_dirs:
	mkdir -p $(html_dirs)

site:
	mkdir -p site

site/%.html: pages/%.md site
	pandoc -s -o $@ $<

.PHONY: toc
toc: _build/markdown/toc.md

_build/markdown:
	mkdir -p $@

_build/markdown/toc.md: SHELL := bash
_build/markdown/toc.md: $(src) _build/markdown
	bash scripts/toc.sh > $@

clean:
	rm -rf _build site