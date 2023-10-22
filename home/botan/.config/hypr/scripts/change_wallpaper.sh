#!/bin/bash

# Define the function for getting a random wallpaper
get_random_wallpaper() {
  dir="${HOME}/.wallpaper"
  current_wallpaper_file="${HOME}/.current_wallpaper"

  # Check if the directory exists
  if [ ! -d "$dir" ]; then
    notify-send "Wallpaper directory $dir does not exist."
    exit 1
  fi

  # Check if there are any wallpapers in the directory
  # Check if there are any wallpapers in the directory
  num_wallpapers=$(find "$dir" -name '*.jpg' -o -name '*.png' -o -name '*.gif' | wc -l)
  if [ "$num_wallpapers" -eq 0 ]; then
    notify-send "No wallpapers found in $dir."
    exit 1
  elif [ "$num_wallpapers" -eq 1 ]; then
    notify-send "Only one wallpaper found in $dir."
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

  # Store the new wallpaper as the current wallpaper
  echo "$wallpaper" > "$current_wallpaper_file"

  echo "$wallpaper"
}

# Define the function for setting wallpapers in Hyprland
set_wallpaper_hyprland() {
  BG=$(get_random_wallpaper)
  
  # Check if a wallpaper was found
  if [ $? -eq 1 ]; then
    exit 1
  fi

  PROGRAM="swww-daemon"

   # Check if the program is running
  if pgrep "$PROGRAM" >/dev/null; then
    swww img "$BG" -t any --transition-bezier 0.0,0.0,1.0,1.0 --transition-duration .8 --transition-step 255 --transition-fps 60
    notify-send "Wallpaper changed" -i "$BG"
  else
    swww init && swww img "$BG" -t any --transition-bezier 0.0,0.0,1.0,1.0 --transition-duration .8 --transition-step 255 --transition-fps 60
    notify-send "Wallpaper changed" -i "$BG"
  fi
}

# Run the appropriate function
set_wallpaper_hyprland

