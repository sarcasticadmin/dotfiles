#!/usr/bin/env bash

# Check for any existing pinetry procs
pkill pinentry

# Update tty
gpg-connect-agent updatestartuptty /bye
