#!/bin/sh
scrot /tmp/screen_locked.png
convert /tmp/screen_locked.png -blur 8x8 /tmp/screen_locked2.png
i3lock -e -f -i /tmp/screen_locked2.png
xset dpms force off
# Need to do something clever here
#doas killall -u root -USR1 moused
