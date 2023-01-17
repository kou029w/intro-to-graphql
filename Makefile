.PHONY: build
build:
	npx @marp-team/marp-cli README.md -o dist/index.html
	rsync -av assets/ dist/assets/
