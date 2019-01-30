CONFIG = make/default-pkgs.mk
PKGS := $(shell cat $(CONFIG))
STOW := $(shell command -v stow 2> /dev/null)

$(HOME)/bin:
	mkdir -p ${HOME}/bin

stow: $(HOME)/bin
	$(foreach pkg, $(PKGS), $(STOW) -R $(pkg);)

unstow:
	$(foreach pkg, $(PKGS), $(STOW) -D $(pkg);)

submodules:
	git submodule update --init

test-md:
	find . -mindepth 2 -type f -iname '*.md' \! \( -path './docs/*' \)

test: test-md
