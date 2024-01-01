#!/bin/bash

# Read the wallpaper file path
BG=$(cat ~/.current_wallpaper)

# Get all connected monitors
MONITORS=$(wlr-randr | awk -F'[* ""]' '{print $1}' | grep -v '^ *$')

# Apply the wallpaper to all monitors
for MONITOR in $MONITORS
do
    swww img "$BG" --outputs $MONITOR --transition-bezier 0.0,0.0,1.0,1.0 --transition-duration .8 --transition-step 255 --transition-fps 60
done
