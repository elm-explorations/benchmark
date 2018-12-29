ELM_FILES = $(shell find src -name '*.elm' -or -name '*.js')
NPM_BIN = $(shell npm bin)
ELM = env PATH=${NPM_BIN}:"${PATH}" elm

.PHONY: all
all: documentation.json test examples/Example.elm.html flow

# package management

node_modules: package.json
	npm install
	touch -m $@

# Elm

documentation.json: ${ELM_FILES} elm.json node_modules
	${ELM} make --docs=$@

.PHONY: test
test: node_modules
	echo "Tests cannot be run due to kernel code" && exit 1
	# ${ELM}-test

examples/%.html: examples/% ${ELM_FILES} node_modules
	echo "examples cannot be run due to kernel code" && exit 1
	# cd examples; ${ELM} make --output $(shell basename $@) $(shell basename $<)

# JavaScript

.PHONY: flow
flow: node_modules
	${NPM_BIN}/flow

# Linting

.PHONY: check-formatting
check-formatting: node_modules
	${ELM}-format --validate $(shell find src tests -name '*.elm' -not -path '*elm-stuff*')
	${NPM_BIN}/prettier -l $(shell find src -name '*.js')

# Meta

.PHONY: clean
clean:
	rm -rf node_modules
	find . -name 'elm-stuff' -type d | xargs rm -rf
	find . -name '*.html' -type f -delete

.PHONY: spellcheck
spellcheck:
	./docs/spellcheck.sh $(shell find src -name '*.elm')
