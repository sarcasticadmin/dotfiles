# Bootstrap scripts

Common place for one shot scripts

## robs-prep-ubuntu.sh

Setup ubuntu with just enough to get going

```
sh robs-prep-ubuntu.sh
```

## robs-install-nix.sh

Setup nixpkgs on systems that are not NixOS

Example:

```
sh robs-install-nix.sh <version>
```
> Requires curl be installed due to nix installation scripts already requiring it
