![Beastie](https://upload.wikimedia.org/wikipedia/en/5/55/Bsd_daemon.jpg)

[![CircleCI](https://circleci.com/gh/sarcasticadmin/dotfiles/tree/master.svg?style=shield)](https://circleci.com/gh/sarcasticadmin/dotfiles/tree/master)

# Robs dotfiles

> "The enjoyment of one's tools is an essential ingredient of successful work." -- Donald E. Knuth

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
```

Call `make` to stow based on predefined `pkgs.mk`
```bash
cd ~/dotfiles
make CONFIG=./make/workstation-pkgs.mk submodules stow
```

### Alternatives

If installing on `Linux` or `OSX` use the `GNUMakefile`:
```bash
make -f GNUMakefile stow
```

#### Submodules

Grab all git submodules without make
```bash
git submodule update --init
```

## Uninstall

Call `make` to unstow based on predefined `workstation-pkgs.mk`
```bash
cd ~/dotfiles
make CONFIG=./make/workstation-pkgs.mk unstow
```

## Submodule Updating
### Update to match this repo

If submodules are bumped to a newer ref and then committed. Other repos pulling this repo down
need to do the following in additition to `git pull --rebase upstream master`:

```
git submodule update
```
> This will update all refs that might still show as diffs in `master`

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
