# Configure OSX Workstation

Leverages `brew` and existing `brewfile`
```
stow workstation-osx
install-brew.sh
brew bundle --global
disable-updates.sh # Get rid of auto update hell
sudo xattr -r -d com.apple.quarantine "/Applications/1Password 7.app"
sudo xattr -r -d com.apple.quarantine "/Applications/Slack.app"
```

## Remove quarantine

Since some of the cask apps didnt come from the app store, apple sets a quaranteen on them. This can be removed with:

```
xattr -r -d com.apple.quarantine "/Applications/<NAME>.app"
```
