#!/bin/bash

# Function to backup the current monitor configuration
backup_monitor_config() {
    echo "Backing up the current monitor configuration..."
    cp ~/.config/hypr/conf/monitors/default.conf ~/.config/hypr/conf/monitors/backup
}

# Function to get information about connected monitors
get_monitor_info() {
    # Get the entire output of `hyprctl monitors`
    output=$(hyprctl monitors)

    # Count the number of monitors
    count=$(echo "$output" | grep -c 'Monitor')

    # Extract monitor names and IDs
    monitors=$(echo "$output" | awk '/Monitor/ {name=$2} /ID/ {print name, $3}')

    # Output the number of monitors and their names
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

    # Display the name of the selected monitor
    echo "Configuring monitor: $selected_monitor"

    # Set the screen resolution for the selected monitor
    screenres=$(gum choose --height 15 $(wlr-randr | grep -oP '\d{3,4}x\d{3,4}' | sort -u -n | tac))
    echo "$screenres"

    # Prompt the user to choose a scale for the display
    scaling=""
    while ! [[ "$scaling" =~ ^[0-9]+(\.[0-9]+)?$ ]] || (( $(awk -v x=$scaling -v y=3 'BEGIN {print (x > y)}') )); do
        read -e -p "Choose a number to set the scale of the display (1-3, default 1): " scaling
        scaling=${scaling:-1}  # Set default to 1 if the input is empty or invalid
    done
    echo "Setting scale to: $scaling"

    # Replace or add the line in the default.conf file
    if grep -q "monitor=$selected_monitor" ~/.config/hypr/conf/monitors/default.conf; then
        sed -i "s/monitor=$selected_monitor,.*/monitor=$selected_monitor,$screenres,auto,$scaling/g" ~/.config/hypr/conf/monitors/default.conf
    else
        echo "monitor=$selected_monitor,$screenres,auto,$scaling" >> ~/.config/hypr/conf/monitors/default.conf
    fi
}

# Function to confirm or restore the monitor configuration
confirm_or_restore_config() {
    # Assuming gum confirm is used to prompt the user for confirmation
    gum confirm "Do you want to use the new monitor configuration?"

    if [ $? -eq 0 ]; then
        echo "New monitor configuration confirmed. Keeping the changes."
        # Add code here to handle the case where the configuration is confirmed
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
