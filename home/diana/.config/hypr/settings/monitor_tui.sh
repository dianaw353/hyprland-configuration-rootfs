#!/bin/bash
echo "This TUI for monitor is created my Diana with love."
# Get the entire output of `hyprctl monitors`
output=$(hyprctl monitors)

# Count the number of monitors
count=$(echo "$output" | grep -c 'Monitor')

# Extract monitor names and IDs
monitors=$(echo "$output" | awk '/Monitor/ {name=$2} /ID/ {print name, $3}')

# Output the number of monitors and their names
echo "Currently there are $count monitors connected, their names are: $(echo "$monitors" | awk '{print $1}' | paste -sd ' ')"

# Prompt the user to select their initial screen resolution
echo "Please select your initial screen resolution. It can be changed later in ~/.config/hypr/hyprland.conf"
echo ""

# Set the same screen resolution for all monitors
for ((i=1; i<=$count; i++)); do
    # Get the name of the current monitor
    monitor_name=$(echo "$monitors" | awk -v i=$i '{if (NR==i) print $1}')

    # Display the name of the current monitor
    echo "Configuring monitor: $monitor_name"

    # Set the screen resolution for the current monitor
    screenres=$(gum choose --height 15 $(wlr-randr | grep -oP '\d{3,4}x\d{3,4}' | sort -u -n | tac))
    echo "$screenres"
    read -e -p "Choose a number to set the scale of the display (default 1): " -i "1" scaling
    if (( $scaling > 3 )); then
        read -e -p "Unsupported scale, Please choose a number between 1-3: " -i "1" scaling
    fi
    echo "$scaling"
    if grep -q "monitor=$monitor_name,.*,.*,.*" config.conf; then
        replace=$(echo "monitor=$monitor_name,$screenres,auto,$scaling")
        sed -i "s/monitor=$monitor_name,.*,.*,.*/$replace/g" config.conf
    else
        echo "monitor=$monitor_name,$screenres,auto,$scaling" >> config.conf
    fi
    swww init
done

echo "Initial screen resolution set to $screenres"
echo "The display port that has been configured is: $(xrandr | grep -w connected | awk '{print $1}')"
echo "No more screens left to configure."
    read -n 1 -s -r -p "Press any key to continue:"

