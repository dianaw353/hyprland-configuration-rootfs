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
    echo "Currently there are $count monitors connected, their names are: $(echo "$monitors" | awk '{print $1}' | paste -sd ' ')"

    # Prompt the user to select their initial screen resolution
    echo "Please select your initial screen resolution. It can be changed later in ~/.config/hypr/conf/monitors/default.conf"
    echo ""
}

# Function to configure monitors
configure_monitors() {
    # Set the same screen resolution for all monitors
    for ((i=1; i<=$count; i++)); do
        # Get the name of the current monitor
        monitor_name=$(echo "$monitors" | awk -v i=$i '{if (NR==i) print $1}')

        # Display the name of the current monitor
        echo "Configuring monitor: $monitor_name"

        # Set the screen resolution for the current monitor
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
        if grep -q "monitor=$monitor_name" ~/.config/hypr/conf/monitors/default.conf; then
            sed -i "s/monitor=$monitor_name,.*/monitor=$monitor_name,$screenres,auto,$scaling/g" ~/.config/hypr/conf/monitors/default.conf
        else
            echo "monitor=$monitor_name,$screenres,auto,$scaling" >> ~/.config/hypr/conf/monitors/default.conf
        fi
    done
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
            configure_monitors
            confirm_or_restore_config
        fi
    fi
}

# Example usage:
backup_monitor_config
get_monitor_info
configure_monitors
confirm_or_restore_config
