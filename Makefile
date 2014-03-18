all: build

.PHONY: build

OPEN_DYLAN_DIR=$(realpath $(dir $(realpath $(shell which dylan-compiler)))/..)

APP_SOURCES = $(wildcard */*.dylan) \
              $(wildcard */*.lid)

REGISTRIES = `pwd`/registry:`pwd`/ext/command-interface/registry:`pwd`/ext/json/registry:`pwd`/ext/serialization/registry:`pwd`/ext/http/registry

build: $(APP_SOURCES)
	OPEN_DYLAN_USER_REGISTRIES=$(REGISTRIES) dylan-compiler -build deft
	# Install things we need to be able to build
	cp -fp $(OPEN_DYLAN_DIR)/lib/*.jam _build/lib/
	cp -rfp $(OPEN_DYLAN_DIR)/lib/runtime _build/lib/runtime
	cp -rfp $(OPEN_DYLAN_DIR)/include _build/include

clean:
	rm -rf _build/bin/deft*
	rm -rf _build/lib/*deft*
	rm -rf _build/build/deft*
