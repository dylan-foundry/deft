all: build

.PHONY: build test

LIB_SOURCES = $(wildcard */*.dylan) \
              $(wildcard */*.lid)

TEST_SOURES = $(wildcard tests/*.dylan) \
              $(wildcard tests/*.lid)

REGISTRIES = `pwd`/registry:`pwd`/ext/command-interface/registry:`pwd`/ext/json/registry:`pwd`/ext/serialization/registry

build: $(LIB_SOURCES)
	OPEN_DYLAN_USER_REGISTRIES=$(REGISTRIES) dylan-compiler -build deft

test: $(LIB_SOURCES) $(TEST_SOURCES)
	OPEN_DYLAN_USER_REGISTRIES=$(REGISTRIES) dylan-compiler -build deft-test-suite-app
	_build/bin/deft-test-suite-app

clean:
	rm -rf _build/bin/deft*
	rm -rf _build/lib/*deft*
	rm -rf _build/build/deft*
