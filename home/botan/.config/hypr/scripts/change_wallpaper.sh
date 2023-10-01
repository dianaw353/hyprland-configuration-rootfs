#!/bin/bash

# Define the function for getting a random wallpaper
get_random_wallpaper() {
  dir="${HOME}/.wallpaper"
  current_wallpaper_file="${HOME}/.current_wallpaper"

  # Check if the directory exists
  if [ ! -d "$dir" ]; then
    echo "Wallpaper directory $dir does not exist."
    exit 1
  fi

  # Get the current wallpaper
  current_wallpaper=""
  if [ -f "$current_wallpaper_file" ]; then
    current_wallpaper=$(cat "$current_wallpaper_file")
  fi

  # Get a random wallpaper that's not the current wallpaper
  wallpaper=""
  while [ -z "$wallpaper" ] || [ "$wallpaper" == "$current_wallpaper" ]; do
    wallpaper=$(find "$dir" -name '*.jpg' -o -name '*.png' -o -name '*.gif' | shuf -n1)
  done

  # Check if a wallpaper was found
  if [ -z "$wallpaper" ]; then
    echo "No wallpapers found in $dir."
    exit 1
  fi

  # Store the new wallpaper as the current wallpaper
  echo "$wallpaper" > "$current_wallpaper_file"

  echo "$wallpaper"
}

# Define the function for setting wallpapers in Hyprland
set_wallpaper_hyprland() {
  BG=$(get_random_wallpaper)
  PROGRAM="swww-daemon"

  # Check if the program is running
  if pgrep "$PROGRAM" >/dev/null; then
    swww img "$BG" -t any --transition-bezier 0.0,0.0,1.0,1.0 --transition-duration .8 --transition-step 255 --transition-fps 60
  else
    swww init && swww img "$BG" -t any --transition-bezier 0.0,0.0,1.0,1.0 --transition-duration .8 --transition-step 255 --transition-fps 60
  fi
}

# Run the appropriate function
set_wallpaper_hyprland

