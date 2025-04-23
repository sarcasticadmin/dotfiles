#!/bin/bash

# This script removes <published>...</published> tags from Atom feed entries
# as this was causing duplicate entries to show up in my feeds. Particularly
# true for https://daily.hamweekly.com/atom.xml
sed -E 's|<published>.*?</published>||g'
