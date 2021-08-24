# git

## hub
> Tested on hub version 2.5.0

If configuring `hub` the following needs to be done outside of `stow`

Create `.gitconfig.d` with `hub` entry:

```sh
mkdir ~/.gitconfig.d
cat << EOF > ~/.gitconfig.d/hub
[hub]
    host = <ghe host>
EOF
```

Additionally create the `hub` config for tokens:
```
cat << EOF > ~/.config/hub
<ghe host>:
- name: <username>
  oauth_token: <token>
  protocol: https
```
> NOTE: This can be repeated n times

## Submodule

Removing submodules was nice and easy doing:

```
git submodule deinit <path_to_submodule>
git rm <path_to_submodule>
```
