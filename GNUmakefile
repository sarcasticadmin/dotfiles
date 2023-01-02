CONFIG = _make/default-pkgs.mk
PKGS := $(shell cat $(CONFIG))
STOW := $(shell command -v stow 2> /dev/null)

include _include/*.mk

$(HOME)/bin:
	mkdir -p ${HOME}/bin

$(HOME)/.config:
	mkdir -p ${HOME}/.config

stow: $(HOME)/bin $(HOME)/.config
	$(foreach pkg, $(PKGS), $(STOW) -R $(pkg);)

unstow:
	$(foreach pkg, $(PKGS), $(STOW) -D $(pkg);)

submodules:
	git submodule update --init

test-md:
	find . -mindepth 2 -type f -iname '*.md' \! \( -path './docs/*' \)

test: test-md

# Install the plugins defined in .vimrc
vim-plug:
	vim -T dumb -c ":PlugInstall" -c ":q" -c ":q"

# Assumes plug entries have been removed from .vimrc
vim-plug-clean:
	vim -T dumb -c ":PlugClean!" -c ":q" -c ":q"

world: submodules stow vim-plug
