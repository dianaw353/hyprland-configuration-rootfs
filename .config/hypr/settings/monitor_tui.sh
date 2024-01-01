#!/bin/bash

figlet "monitor"

# Function to backup the current monitor configuration with date and time
backup_monitor_config() {
    echo "Backing up the current monitor configuration..."

    # Specify the backup folder
    backup_folder=~/.config/hypr/conf/monitors/backup/

    # Create the backup folder if it doesn't exist
    mkdir -p "$backup_folder"

    # Adding date and time to the backup file name
    backup_file="$backup_folder"backup_$(date +"%Y%m%d%H%M%S").conf

    cp ~/.config/hypr/conf/monitors/default.conf "$backup_file"

    echo "Backup saved to $backup_file"
}

# Function to restore the backup configuration
restore_backup_config() {
    # Prompt user to restore configuration
    gum confirm "Do you want to restore a backup configuration?"

    if [ $? -eq 0 ]; then
        # Specify the backup folder
        backup_folder=~/.config/hypr/conf/monitors/backup/

        # List available backup files
        available_files=("$backup_folder"*)
        if [ ${#available_files[@]} -eq 0 ]; then
            echo "No backup files found in $backup_folder. Skipping restore."
            return
        fi

        # Prompt user to choose a file to restore
        selected_backup_file=$(gum choose --height 15 "${available_files[@]}")

        # Check if the selected file exists
        if [ -f "$selected_backup_file" ]; then
            cp "$selected_backup_file" ~/.config/hypr/conf/monitors/default.conf
file            echo "Configuration restored successfully from $selected_backup_file."

            # Prompt user to continue configuration or exit
            gum confirm "Do you want to continue the configuration or exit the script?"

            if [ $? -eq 0 ]; then
                return
            else
                exit
            fi
        else
            echo "Backup file $selected_backup_file not found. Skipping restore."
        fi
    else
        echo "Skipping restore."
    fi
}

# Function to enable a disabled monitor
enable_monitor() {
    get_monitor_info

    # Filter out disabled monitors
    disabled_monitors=$(grep ",disable" ~/.config/hypr/conf/monitors/default.conf | cut -d',' -f1 | sed 's/^monitor=//')

    if [ -z "$disabled_monitors" ]; then
        echo "No disabled monitors found."
        return
    fi

    # Prompt to select a disabled monitor to enable
    echo "Choose the disabled monitor to enable:"
    monitor_to_enable=$(gum choose --height 15 $disabled_monitors)
    echo "Selected disabled monitor to enable: $monitor_to_enable"

    # Use grep to find the corresponding lines in backup files
    backup_folder=~/.config/hypr/conf/monitors/backup/
    matching_lines=$(grep "^monitor=$monitor_to_enable," $backup_folder* | cut -d':' -f2)

    if [ -z "$matching_lines" ]; then
        echo "No matching lines found in backup files for monitor $monitor_to_enable."
        return
    fi

    # Prompt to choose a matching line
    echo "Choose a line to restore from:"
    chosen_line=$(echo "$matching_lines" | gum choose --height 15)

    # Replace the line in default.conf with the chosen line
    sed -i "/^monitor=$monitor_to_enable/s/.*/$chosen_line/" ~/.config/hypr/conf/monitors/default.conf

    echo "Monitor $monitor_to_enable has been enabled using the chosen backup line."
    # Prompt user to configure the monitor or exit the script
    gum confirm "Do you want to configure the monitor?"

    if [ $? -eq 0 ]; then
        # Add your code here for configuring the monitor
        echo "Configuring the monitor..."
    else
        echo "Exiting the script."
        exit 0
    fi
}

# Function to disable a monitor
disable_monitor() {
    get_monitor_info
    count=$(echo "$monitors" | awk '{print $1}' | wc -l)

    if [ "$count" -gt 1 ]; then
        gum confirm "Do you want to disable a monitor?"

        if [ $? -eq 0 ]; then
            available_monitors=$(echo "$monitors" | awk '{print $1}' | paste -sd ' ')

            if [ -z "$available_monitors" ]; then
                echo "No available monitors to disable."
                return
            fi

            # Prompt to select a monitor to disable
            echo "Choose the monitor to disable:"
            monitor_to_disable=$(gum choose --height 15 $available_monitors)
            echo "Selected monitor to disable: $monitor_to_disable"

            # Use sed to replace the line with monitor=<monitor_name>,disable in the configuration file
            sed -i "/^monitor=$monitor_to_disable/s/.*/monitor=$monitor_to_disable,disable/" ~/.config/hypr/conf/monitors/default.conf

            echo "Monitor $monitor_to_disable has been disabled."
            exit 0
        else
            echo "Skipping monitor disable option."
        fi
    else
        echo "Only one monitor connected. Skipping monitor disable option."
    fi
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

    # Select scale
    scaling=""
    while ! [[ "$scaling" =~ ^[0-9]+(\.[0-9]+)?$ ]] || (( $(awk -v x=$scaling -v y=3 'BEGIN {print (x > y)}') )); do
        echo "Select your desired scale for your screen (1-3, default 1):"
        scaling=$(gum input --placeholder "Enter the scale (1-3, default 1): ")
        scaling=${scaling:-1}  # Set default to 1 if the input is empty or invalid
    done
    echo "Setting scale to: $scaling"

         # Replace or add the line in the default.conf file
    if grep -q "monitor=$selected_monitor" ~/.config/hypr/conf/monitors/default.conf; then
        sed -i "s/monitor=$selected_monitor,.*/monitor=$selected_monitor,$screenres@$refreshrate,auto,$scaling/g" ~/.config/hypr/conf/monitors/default.conf
    else
        echo "monitor=$selected_monitor,$screenres@$refreshrate,auto,$scaling" >> ~/.config/hypr/conf/monitors/default.conf
    fi
}

# Function to configure advanced settings
configure_advanced_settings() {
    gum confirm "Do you want to configure advanced settings for monitors?"

    if [ $? -eq 0 ]; then
        gum confirm "Do you want to enable 10-bit support?"

        if [ $? -eq 0 ]; then
            echo "Enabling 10-bit support..."
            # Add your code here to enable 10-bit support
        else
            echo "10-bit support will not be enabled."
        fi

        monitors=$(echo "$monitors" | awk '{print $1}' | paste -sd ' ')

        # Check if there is more than one monitor to mirror
        if [ $(echo "$monitors" | wc -l) -gt 1 ]; then
            gum confirm "Do you want to set up a mirrored display?"

            if [ $? -eq 0 ]; then
                # Prompt to select the main monitor for mirroring
                echo "Choose the main monitor for mirroring:"
                main_monitor=$(gum choose --height 15 $monitors)
                echo "Selected main monitor for mirroring: $main_monitor"

                # Now, prompt to select the monitor to mirror
                available_monitors=$(echo "$monitors" | grep -v "$main_monitor" | awk '{print $1}' | paste -sd ' ')
                echo "Choose the monitor to mirror:"
                mirror_monitor=$(gum choose --height 15 $available_monitors)
                echo "Selected monitor to mirror: $mirror_monitor"

                # Add your code here to set up mirror display using $main_monitor and $mirror_monitor variables
            else
                echo "Mirror display will not be set up."
            fi
        else
            echo "Only one monitor available. Skipping mirroring configuration."
        fi

        gum confirm "Do you want to rotate a monitor?"

        if [ $? -eq 0 ]; then
            echo "Choose the rotation option:"
            rotation_option=$(gum choose --height 15 "normal (no transforms) -> 0" "90 degrees -> 1" "180 degrees -> 2" "270 degrees -> 3" "flipped -> 4" "flipped + 90 degrees -> 5" "flipped + 180 degrees -> 6" "flipped + 270 degrees -> 7")
            echo "Selected rotation option: $rotation_option"
            # Add your code here to apply the selected rotation option
        else
            echo "No rotation will be applied."
        fi

        gum confirm "Do you want to control VRR (Adaptive Sync) of your monitors? 0 - off, 1 - on, 2 - fullscreen only"
        vrr_option=$(gum choose --height 15 "VRR off -> 0" "VRR on -> 1" "VRR fullscreen only -> 2")

        case $vrr_option in
            0)
                echo "VRR (Adaptive Sync) will be turned off."
                # Add your code here to handle VRR off
                ;;
            1)
                echo "VRR (Adaptive Sync) will be turned on."
                # Add your code here to handle VRR on
                ;;
            2)
                echo "VRR (Adaptive Sync) will be set to fullscreen only."
                # Add your code here to handle VRR fullscreen only
                ;;
            *)
                echo "Invalid option. Skipping VRR configuration."
                ;;
        esac

    else
        echo "Skipping advanced settings configuration."
    fi
}

# Function to confirm or restore the monitor configuration and configure advanced settings
confirm_or_restore_config() {
    gum confirm "Do you want to use the new monitor configuration?"

    if [ $? -eq 0 ]; then
        echo "New monitor configuration confirmed. Keeping the changes."

        configure_advanced_settings
    else
        echo "Restoring the old configuration..."

        # Check if there are backup files in the specified folder
        backup_folder=~/.config/hypr/conf/monitors/backup/
        if [ -n "$(ls -A $backup_folder)" ]; then
            cp "$backup_file" ~/.config/hypr/conf/monitors/default.conf
        else
            echo "No backup files found in $backup_folder. Skipping restore."
        fi

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
restore_backup_config
enable_monitor
disable_monitor
get_monitor_info
selected_monitor=$(select_monitor)
configure_monitors "$selected_monitor"
confirm_or_restore_config

echo "Initial screen resolution set to $selected_resolution"
echo "The display port that has been configured is: $(wlr-randr | grep -w connected | awk '{print $1}')"
echo "No more screens left to configure."
