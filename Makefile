.PHONY: build
build:
	bash build.sh

.PHONY: clean
clean:
	rm -rf _build docs

.PHONY: serve
serve:
	cd docs && python3 -m http.server

.PHONY: readme
readme:
	bash readme.sh