CONFIG = make/default-pkgs.mk
PKGS != cat $(CONFIG)
STOW != command -v stow 2> /dev/null

$(HOME)/bin:
	mkdir -p ${HOME}/bin

stow: $(HOME)/bin
.for pkg in $(PKGS)
	$(STOW) -R $(pkg)
.endfor

unstow:
.for pkg in $(PKGS)
	$(STOW) -D $(pkg)
.endfor

submodules:
	git submodule update --init

test-md:
	test $$(find . -type f -iname '*.md' \! \( -path './docs/*' \) -d 2 | wc -c) -eq 0; \
	  echo "Docs Look good!"

test: test-md

# Install the plugins defined in .vimrc
vim-plug:
	vim -T dumb -c ":PlugInstall" -c ":q" -c ":q"

world: submodules stow vim-plug
