all: build

.PHONY: build

APP_SOURCES = $(wildcard */*.dylan) \
              $(wildcard */*.lid)

REGISTRIES = `pwd`/registry:`pwd`/ext/command-interface/registry:`pwd`/ext/json/registry:`pwd`/ext/serialization/registry

build: $(APP_SOURCES)
	OPEN_DYLAN_USER_REGISTRIES=$(REGISTRIES) dylan-compiler -build deft

clean:
	rm -rf _build/bin/deft*
	rm -rf _build/lib/*deft*
	rm -rf _build/build/deft*
