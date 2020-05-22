.PHONY: build
build:
	bash build.sh

.PHONY: clean
clean:
	rm -rf _build site

.PHONY: serve
serve:
	cd site && python3 -m http.server
