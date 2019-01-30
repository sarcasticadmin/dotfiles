# Robs dotfiles

[![CircleCI](https://circleci.com/gh/sarcasticadmin/dotfiles/tree/master.svg?style=shield)](https://circleci.com/gh/sarcasticadmin/dotfiles/tree/master)

![Beastie](https://upload.wikimedia.org/wikipedia/en/5/55/Bsd_daemon.jpg)

`FreeBSD` 1st dotfiles with an effort to make it work on any *nix environment

## Installation
Dependencies:
```bash
su -
pkg install stow
exit
```

Clone down repo and grab all git submodules:
```bash
cd ~
git clone git@github.com/sarcasticadmin/dotfiles.git
git submodule update --init
```

Call `make` to stow based on predefined `pkgs.mk`
```bash
cd ~/dotfiles
make CONFIG=./make/workstation-pkgs.mk stow
```

### Alternatives
If installing on `Linux` or `OSX` use the `GNUMakefile`:
```bash
make -f GNUMakefile stow
```

## Uninstall

Call `make` to unstow based on predefined `workstation-pkgs.mk`
```bash
cd ~/dotfiles
make CONFIG=./make/workstation-pkgs.mk unstow
```

## Updating
### vim bundles
Individual update of a vim plugin
```bash
cd ~/dotfiles/vim/.vim/bundle/salt
git pull origin master
```

Bulk upgrade all plugins:
```bash
cd ~/dotfiles/vim/.vim/
git submodule foreach git pull origin master
```

## Docs

[See more documentation](./docs/README.md)
