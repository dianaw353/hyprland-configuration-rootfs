#!/bin/bash
#  _              _     _           _ _                  
# | | _____ _   _| |__ (_)_ __   __| (_)_ __   __ _ ___  
# | |/ / _ \ | | | '_ \| | '_ \ / _` | | '_ \ / _` / __| 
# |   <  __/ |_| | |_) | | | | | (_| | | | | | (_| \__ \ 
# |_|\_\___|\__, |_.__/|_|_| |_|\__,_|_|_| |_|\__, |___/ 
#           |___/                             |___/      
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

# ----------------------------------------------------- 
# Get keybindings location based on variation
# ----------------------------------------------------- 
config_file=$(cat ~/.config/hypr/conf/keybinds.conf)
config_file=${config_file/source = ~/}
config_file=${config_file/source=~/}

# ----------------------------------------------------- 
# Path to keybindings config file
# ----------------------------------------------------- 
config_file="/home/$USER$config_file"
echo "Reading from: $config_file"

# ----------------------------------------------------- 
# Parse keybindings
# ----------------------------------------------------- 
keybinds=$(grep -oP '(?<=bind = ).*' $config_file)
keybinds=$(echo "$keybinds" \
       | sed 's/$mainMod./󰣇 +/g' \
       | sed 's/$mainMod/󰣇 /g' \
       | sed 's/ALT/⎇ +/g' \
       | sed 's/CTRL/⌃ +/g' \
       | sed 's/SPACE/␣/g' \
       | sed 's/ENTER/⏎ +/g' \
       | sed 's/SHIFT/⇧ +/g' \
       | sed 's/,.XF86AudioMute//g' \
       | sed 's/,.XF86AudioRaiseVolume//g' \
       | sed 's/,.XF86AudioLowerVolume//g' \
       | sed 's/,.XF86AudioPlay//g' \
       | sed 's/,.XF86AudioNext//g' \
       | sed 's/,.XF86AudioPrev//g' \
       | sed 's/,.XF86audiostop//g' \
       | sed 's/,.XF86MonBrightnessDown//g' \
       | sed 's/,.XF86MonBrightnessUp/󰖨/g' \
       | sed 's/, exec//g' \
       | sed 's/1,/⓵ +/g' \
       | sed 's/2,/⓶ +/g' \
       | sed 's/3,/⓷ +/g' \
       | sed 's/4,/⓸ +/g' \
       | sed 's/5,/⓹ +/g' \
       | sed 's/6,/⓺ +/g' \
       | sed 's/7,/⓻ +/g' \
       | sed 's/8,/⓼ +/g' \
       | sed 's/9,/⓽ +/g' \
       | sed 's/0,/⓪ +/g' \
       | sed 's/A,/ⓐ/g' \
       | sed 's/B,/ⓑ/g' \
       | sed 's/C,/ⓒ/g' \
       | sed 's/D,/ⓓ/g' \
       | sed 's/E,/ⓔ/g' \
       | sed 's/F,/ⓕ/g' \
       | sed 's/G,/ⓖ/g' \
       | sed 's/H,/ⓗ/g' \
       | sed 's/I,/ⓘ/g' \
       | sed 's/J,/ⓙ/g' \
       | sed 's/K,/ⓚ/g' \
       | sed 's/L,/ⓛ/g' \
       | sed 's/M,/ⓜ/g' \
       | sed 's/N,/ⓝ/g' \
       | sed 's/O,/ⓞ/g' \
       | sed 's/P,/ⓟ/g' \
       | sed 's/Q,/ⓠ/g' \
       | sed 's/R,/ⓡ/g' \
       | sed 's/S,/ⓢ/g' \
       | sed 's/T,/ⓣ/g' \
       | sed 's/U,/ⓤ/g' \
       | sed 's/V,/ⓥ/g' \
       | sed 's/W,/ⓦ/g' \
       | sed 's/X,/ⓧ/g' \
       | sed 's/Y,/ⓨ/g' \
       | sed 's/Z,/ⓩ/g' \
       | sed 's/,//g' \
       | sed 's/,\([^,]*\)$/ = \1/') 
       
# ----------------------------------------------------- 
# Show keybindings in rofi
# ----------------------------------------------------- 
rofi -dmenu -i -replace -p "Keybinds" -config ~/.config/rofi/config-compact.rasi <<< "$keybinds"

