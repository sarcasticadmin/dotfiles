#!/bin/sh

# check the value of DPMS: xset q

# Revert all temporary behavior after logging back in
revert() {
  # Disable screen blank
  xset s off
  # "Disable" DPMS
  # Its better to zero out the dpms values than disable dpms: xset -dpms
  # Since its easy for other things to reenable it
  # e.g.: xset dpms force off (force screen off)
  xset dpms 0 0 0
}

# trigger revert for all process signals, mainly EXIT
trap revert HUP INT TERM EXIT

# Screenshot then fast blur the current screen
scrot - | convert - -scale 10% -blur 0x2.5 -resize 1000% /tmp/i3lock.png
# Temporary set vals for DPMS while locked (in seconds)
# standby | suspend | off
# off must be equal to or greater than standby and suspend
xset dpms 0 0 600
i3lock -n -e -f -i /tmp/i3lock.png
