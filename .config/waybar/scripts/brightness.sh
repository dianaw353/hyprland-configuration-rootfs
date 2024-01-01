#!/bin/bash

# Function to adjust brightness
adjust_brightness() {
    local operation=$1
    declare -A operations=( ["increase"]="-A" ["decrease"]="-U" )
    brillo -u 15000 ${operations[$operation]} 2
    # Send a signal to Waybar to update the brightness
    pkill -RTMIN+10 waybar
}

# Adjust the brightness based on the argument
case "$1" in
    "increase"|"decrease") adjust_brightness $1 ;;
esac

# Get the current brightness and convert it to an integer
brightness=$(printf "%.0f" "$(brillo -G)")

# Define the icons
icons=("󰃞" "󰃟" "󰃝" "󰃠")

# Calculate the index based on the brightness percentage
index=$(( brightness / 25 ))

# Correct the index if brightness is 100
(( brightness == 100 )) && index=3

# Print the icon and the brightness percentage
printf '{"text":"%s %s%%"}\n' "${icons[$index]}" "$brightness"
