#!/bin/bash

# Read the wallpaper file path
BG=$(cat ~/.current_wallpaper)

# Apply the wallpaper
swww img "$BG" -t any --transition-bezier 0.0,0.0,1.0,1.0 --transition-duration .8 --transition-step 255 --transition-fps 60

