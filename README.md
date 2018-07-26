# Robs dotfiles

`FreeBSD` 1st dotfiles with an effort to make it work on any *nix environment

## Installation
Dependencies:
```bash
pkg install vim stow
```

```bash
cd ~
git clone git@github.com/sarcasticadmin/dotfiles.git ~/dotfiles
git submodule update --init
```

Stow to mount which dotfiles into the home directory:
```bash
cd ~/dotfiles
stow vim
stow bash
stow tmux
```

## Updating vim bundles
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
