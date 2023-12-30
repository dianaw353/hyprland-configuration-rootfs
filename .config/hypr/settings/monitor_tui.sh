#!/bin/bash

figlet "monitor"

# Function to backup the current monitor configuration
backup_monitor_config() {
    echo "Backing up the current monitor configuration..."
    cp ~/.config/hypr/conf/monitors/default.conf ~/.config/hypr/conf/monitors/backup
}

# Function to get information about connected monitors
get_monitor_info() {
    output=$(hyprctl monitors)
    count=$(echo "$output" | grep -c 'Monitor')
    monitors=$(echo "$output" | awk '/Monitor/ {name=$2} /ID/ {print name, $3}')

    echo "Currently, there are $count monitors connected:"
    echo "$monitors" | awk '{print "" $1}'
    echo ""
}

# Function to select a monitor from the list
select_monitor() {
    monitor_list=$(echo "$monitors" | awk '{print $1}' | paste -sd ' ')
    selected_monitor=$(gum choose --height 15 $monitor_list)
    echo "$selected_monitor"
}

# Function to configure monitors
configure_monitors() {
    selected_monitor=$1

    echo "Selected monitor: $selected_monitor"

    # Select screen resolution
    echo "Select your desired screen resolution for $selected_monitor:"
    screenres=$(wlr-randr | awk -v selected_monitor="$selected_monitor" '/^'"$selected_monitor"'/,/^$/ {print $1}' | sed '/^$/d' | grep -oP '\d{3,4}x\d{3,4}' | sort -u -n | tac | gum choose --height 15)
    echo "Setting screen resolution for $selected_monitor to be: $selected_resolution"

    # Select refresh rate
    echo "Select your desired refresh rate:"
    refreshrate=$(wlr-randr | awk -v selected_monitor="$selected_monitor" '/^'"$selected_monitor"'/,/^$/ {print $0}' | grep -oP '\d{1,3}\.\d{6}' | awk '{printf("%.0f\n", $1)}' | sort -u -n | tac | gum choose --height 15)
    echo "You chose the refresh rate to be: $refreshrate"

    # Select position
    echo "Please select the position of the display relative to other displays"
    position=$(gum choose --height 15 "auto" "right" "left")
    echo "Setting position to: $position"

    # Select scale
    scaling=""
    while ! [[ "$scaling" =~ ^[0-9]+(\.[0-9]+)?$ ]] || (( $(awk -v x=$scaling -v y=3 'BEGIN {print (x > y)}') )); do
        echo "Select your desired scale for your screen (1-3, default 1):"
        scaling=$(gum input --placeholder "Enter the scale (1-3, default 1): ")
        scaling=${scaling:-1}  # Set default to 1 if the input is empty or invalid
    done
    echo "Setting scale to: $scaling"

    # Extract x and y resolutions
    x_resolution=$(echo "$screenres" | cut -d'x' -f1)
    y_resolution=$(echo "$screenres" | cut -d'x' -f2)
    
    case $position in
    "auto")
        position_res="auto"
        ;;
    "right")
        position_res="${x_resolution}x0"
        ;;
    "left")
        position_res="-${x_resolution}x0"
        ;;
    *)
        echo "Invalid position. Defaulting to top-right."
        position_res="${x_resolution}x0"
        ;;
    esac

     # Replace or add the line in the default.conf file
    if grep -q "monitor=$selected_monitor" ~/.config/hypr/conf/monitors/default.conf; then
        sed -i "s/monitor=$selected_monitor,.*/monitor=$selected_monitor,$screenres@$refreshrate,$position_res,$scaling/g" ~/.config/hypr/conf/monitors/default.conf
    else
        echo "monitor=$selected_monitor,$screenres@$refreshrate,auto,$scaling" >> ~/.config/hypr/conf/monitors/default.conf
    fi
}

# Function to confirm or restore the monitor configuration
confirm_or_restore_config() {
    gum confirm "Do you want to use the new monitor configuration?"

    if [ $? -eq 0 ]; then
        echo "New monitor configuration confirmed. Keeping the changes."
        # Handle configuration confirmation here
    else
        echo "Restoring the old configuration..."
        cp ~/.config/hypr/conf/monitors/backup ~/.config/hypr/conf/monitors/default.conf
        gum confirm "Do you want to try configuring the monitor again?"

        if [ $? -eq 0 ]; then
            selected_monitor=$(select_monitor)
            configure_monitors "$selected_monitor"
            confirm_or_restore_config
        fi
    fi
}

# Example usage:
backup_monitor_config
get_monitor_info
selected_monitor=$(select_monitor)
configure_monitors "$selected_monitor"
confirm_or_restore_config

echo "Initial screen resolution set to $selected_resolution"
echo "The display port that has been configured is: $(wlr-randr | grep -w connected | awk '{print $1}')"
echo "No more screens left to configure."
