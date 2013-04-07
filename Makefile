all: build

.PHONY: build test

LIB_SOURCES = $(wildcard */*.dylan) \
              $(wildcard */*.lid)

TEST_SOURES = $(wildcard tests/*.dylan) \
              $(wildcard tests/*.lid)

build: $(LIB_SOURCES)
	dylan-compiler -build deft

test: $(LIB_SOURCES) $(TEST_SOURCES)
	dylan-compiler -build deft-test-suite-app
	_build/bin/deft-test-suite-app

clean:
	rm -rf _build/bin/deft*
	rm -rf _build/lib/*deft*
	rm -rf _build/build/deft*
