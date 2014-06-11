all: build

.PHONY: build

OPEN_DYLAN_DIR = $(realpath $(dir $(realpath $(shell which dylan-compiler)))/..)

INSTALL_DIR ?= /opt/deft

APP_SOURCES = $(wildcard */*.dylan) \
              $(wildcard */*.lid)

REGISTRIES = `pwd`/registry:`pwd`/ext/command-interface/registry:`pwd`/ext/json/registry:`pwd`/ext/serialization/registry:`pwd`/ext/http/registry

ifeq (, $(wildcard .git))
check-submodules:
else
check-submodules:
	@for sms in `git submodule status --recursive | grep -v "^ " | cut -c 1`; do \
	  if [ "$$sms" != "x" ]; then \
	    echo "**** ERROR ****"; \
	    echo "One or more submodules is not up to date."; \
	    echo "Please run 'git submodule update --init --recursive'."; \
	    exit 1; \
	  fi; \
	done;
endif

build: $(APP_SOURCES) check-submodules
	OPEN_DYLAN_USER_REGISTRIES=$(REGISTRIES) dylan-compiler -build deft
	# Install things we need to be able to build
	cp -fp $(OPEN_DYLAN_DIR)/lib/*.jam _build/lib/
	cp -rfp $(OPEN_DYLAN_DIR)/lib/runtime _build/lib/
	if [ -d $(OPEN_DYLAN_DIR)/include ]; then \
	  cp -rfp $(OPEN_DYLAN_DIR)/include _build/; \
	fi
	ln -fs $(OPEN_DYLAN_DIR)/sources _build/
	# deft-dfmc/tracing stuff:
	mkdir -p _build/share/static/dfmc-tracing
	cp -rp deft-dfmc/static/* _build/share/static/dfmc-tracing/

clean:
	rm -rf _build/bin/deft*
	rm -rf _build/lib/*deft*
	rm -rf _build/build/deft*

install: build
	mkdir -p $(INSTALL_DIR)
	cp -rp _build/bin $(INSTALL_DIR)/
	cp -rfp _build/lib $(INSTALL_DIR)/
	cp -rp _build/share $(INSTALL_DIR)/
	cp -rp _build/databases $(INSTALL_DIR)/
	if [ -d _build/include ]; then \
	  cp -rfp _build/include $(INSTALL_DIR)/; \
	fi
	ln -fs $(OPEN_DYLAN_DIR)/sources $(INSTALL_DIR)/
