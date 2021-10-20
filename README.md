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
make CONFIG=./_make/workstation-pkgs.mk world
```

### Alternatives

* If installing on `Linux` or `OSX` itll leverage the `GNUmakefile` instead of the BSD `Makefile`

#### Submodules

Grab all git submodules without make
```bash
git submodule update --init
```

## Uninstall

Call `make` to unstow based on predefined `workstation-pkgs.mk`
```bash
cd ~/dotfiles
make CONFIG=./_make/workstation-pkgs.mk unstow
```

## Submodule Updating
### Update to match this repo

If submodules are bumped to a newer ref and then committed. Other repos pulling this repo down
need to do the following in additition to `git pull --rebase upstream master`:

```
git submodule update
```
> This will update all refs that might still show as diffs in `master`

### git submodules

Individual update of rbenv:

```bash
cd ~/dotfiles/vim/.vim/bundle/salt
git pull origin master
```

Bulk upgrade all mutliple git submodules:

```bash
cd <to submodules dir>
git submodule foreach git pull origin master
```

## Docs

- [bootstrap misc](./_bootstrap/README.md)
- [See more documentation](./docs/README.md)
