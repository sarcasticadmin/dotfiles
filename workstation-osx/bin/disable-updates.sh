#!/usr/bin/env bash
# https://www.launchd.info/
# http://www.dowdandassociates.com/blog/content/howto-set-an-environment-variable-in-mac-os-x-home-slash-dot-macosx-slash-environment-dot-plist/
# Disable squirrel updates
# https://github.com/Squirrel/Squirrel.Mac/issues/192
# Specifically disable slack ap push updates (squirrel framework)
# https://rickheil.com/disabling-auto-updates-on-slack-for-mac/
# set launchd envs
LAUNCHD_SETENVS=("DISABLE_UPDATE_CHECK" "SLACK_NO_AUTO_UPDATES")

for setenv in "${LAUNCHD_SETENVS[@]}"; do
  # shellcheck disable=SC2086
  cat << EOF | sudo tee /Library/LaunchAgents/com.sarcasticadmin.${setenv}.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
  <dict>
  <key>Label</key>
  <string>com.sarcasticadmin.${setenv}</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/launchctl</string>
    <string>setenv</string>
    <string>${setenv}</string>
    <string>1</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>ServiceIPC</key>
  <false/>
</dict>
</plist>
EOF
  # Since this is in LaunchAgents it will autoload on start
  # shellcheck disable=SC2086
  launchctl load -w /Library/LaunchAgents/com.sarcasticadmin.${setenv}.plist
  # Below doesnt work consistently if the above is already applied
  #if [ "$(/bin/launchctl getenv ${setenv})" ]; then
  #  echo "launchctl set for ${setenv}"
  #else
  #  echo "[FAILED] launchctl notset for ${setenv}...exiting"
  #  exit 1
  #fi
done
