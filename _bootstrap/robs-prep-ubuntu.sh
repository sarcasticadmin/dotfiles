#!/bin/sh

# Bare minimuium that I need to get up and running if on Ubuntu
# Leave the rest of nix
sudo apt-get update
sudo apt-get install stow tmux vim git curl xsel \
             gnupg2 gnupg-agent gnupg-curl scdaemon pcscd pinentry-tty # pgp card

# Turn off ondemand CPU schedule that slows the system down
sudo systemctl stop ondemand
sudo systemctl disable ondemand

# Verify that its good
sudo cat /sys/devices/system/cpu/cpufreq/policy*/scaling_governor
echo "will need to reboot to clear ondemand cpu scheduling"
