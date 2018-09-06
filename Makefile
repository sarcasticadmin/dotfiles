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
