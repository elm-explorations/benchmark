ELM_FILES = $(shell find src -name '*.elm' -or -name '*.js')

.PHONY: all
all: documentation.json flow check-formatting

# package management

node_modules: package.json
	npm install
	touch -m $@

# Elm

documentation.json: ${ELM_FILES} elm.json node_modules
	npx elm make --docs=$@

.PHONY: test
test: node_modules
	echo "Tests cannot be run due to kernel code" && exit 1
	# npx elm-test

examples/%.html: examples/% ${ELM_FILES} node_modules
	echo "examples cannot be run due to kernel code" && exit 1
	# cd examples; npx elm make --output ${@F} ${<F}

# JavaScript

.PHONY: flow
flow: node_modules
	npx flow check src

# Linting

.PHONY: check-formatting
check-formatting: node_modules
	npx elm-format --validate $(shell find src tests -name '*.elm')
	npx prettier -l $(shell find src -name '*.js')

# Meta

.PHONY: clean
clean:
	rm -rf node_modules
	find . -name 'elm-stuff' -type d | xargs rm -rf
	find . -name '*.html' -type f -delete

.PHONY: spellcheck
spellcheck:
	./docs/spellcheck.sh $(shell find src -name '*.elm')
