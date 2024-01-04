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

restore_backup_config() {
    gum confirm "Do you want to restore a backup configuration?"

    if [ $? -eq 0 ]; then
        backup_folder=~/.config/hypr/conf/monitors/backup/
        available_files=("$backup_folder"*)
        
        if [ ${#available_files[@]} -eq 0 ]; then
            echo "No backup files found in $backup_folder. Skipping restore."
            return
        fi

        # Sort files by modification time in reverse order to get the latest file first
        sorted_files=($(ls -t "$backup_folder"))

        selected_backup_file=$(gum choose --height 15 "${sorted_files[@]}")
        selected_backup_file="$backup_folder$selected_backup_file"

        if [ -f "$selected_backup_file" ]; then
            cp "$selected_backup_file" ~/.config/hypr/conf/monitors/default.conf
            echo "Configuration restored successfully from $selected_backup_file."

            gum confirm "Do you want to continue the configuration or exit the script?"

            if [ $? -eq 0 ]; then
                return
            else
                exit 0
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

    echo "What monitor do you want to configure?"
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
    scaling=$(gum input --placeholder "Enter the desired fractional scale for your display (decimales recommended): ")
    scaling=${scaling:-1}  # Set default to 1 if the input is empty or invalid
done

# Ask the user if they want to disable fractional scaling on X11 applications
disable_fractional_scaling=false
if (( $(awk -v x=$scaling -v y=1 'BEGIN {print (x > y)}') )); then
        echo " Disabling fractional scaling on only X11(xwayland) applications is HIGHLY RECOMMEMNED.  This is because with fractional scaling the applications that do not support wayland yet become fuzzy and blurry. As a workaround we found that disabling factional scaling for only X11(xwayland) applicaions to not be fuzzy/burry."
    gum confirm "Disable fractional scaling on X11(xwayland) applications for the selected scale?" && disable_fractional_scaling=true
fi

# Modify the configuration file based on user's choice
config_file=~/.config/hypr/conf/custom.conf

# Set force_zero_scaling based on user's choice
force_zero_scaling=""
if [ "$disable_fractional_scaling" = true ]; then
    force_zero_scaling=true
else
    force_zero_scaling=false
fi

# Check if the lines already exist and replace them
if grep -q "xwayland {" "$config_file"; then
    sed -i "/xwayland {/,/}/ s/force_zero_scaling = .*/force_zero_scaling = $force_zero_scaling/" "$config_file"
else
    # If the block doesn't exist, add it to the end of the file
    echo -e "\nxwayland {" >> "$config_file"
    echo -e "\tforce_zero_scaling = $force_zero_scaling" >> "$config_file"
    echo "}" >> "$config_file"
fi

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

        # Find the selected monitor in the configuration
monitor_line=$(grep "^monitor=$selected_monitor," ~/.config/hypr/conf/monitors/default.conf)

if [ -n "$monitor_line" ]; then
    # Add ,bitdepth,10 to the end of the line
    sed -i "s/$monitor_line/$monitor_line,bitdepth,10/" ~/.config/hypr/conf/monitors/default.conf
    echo "10-bit support added to the configuration for $selected_monitor."
else
    echo "Selected monitor $selected_monitor not found in the configuration. 10-bit support not added."
fi
    else
        echo "10-bit support will not be enabled."
    fi

# Check if there is more than one monitor to mirror
if [ $(echo "$monitors" | wc -l) -gt 1 ]; then
    gum confirm "Do you want to set up a mirrored display?"

    if [ $? -eq 0 ]; then
        # Now, prompt to select the monitor to mirror
        available_monitors=$(echo "$monitors" | grep -v "$selected_monitor" | awk '{print $1}' | paste -sd ' ')

        if [ -n "$available_monitors" ]; then
            echo "Choose the monitor to mirror:"
            mirror_monitor=$(gum choose --height 15 $available_monitors)
            echo "Selected monitor to mirror: $mirror_monitor"

            # Add mirror configuration to default.conf
            sed -i "/^monitor=$selected_monitor/s/$/,mirror,$mirror_monitor/" ~/.config/hypr/conf/monitors/default.conf

            echo "Mirror display configured for $selected_monitor: ,mirror,$mirror_monitor"
        else
            echo "No available monitors to mirror."
        fi
    else
        echo "Mirror display will not be set up."
    fi
else
    echo "Only one monitor available. Skipping mirroring configuration."
fi

if [ $? -eq 0 ]; then
    echo "Do you want to control VRR (Adaptive Sync) of your monitors?"
    vrr_option=$(gum choose --height 15 "0" "1" "2")

    echo "Debug: Chosen option is $vrr_option"

    case $vrr_option in
        0)
            echo "VRR (Adaptive Sync) will be turned off."
            ;;
        1)
            echo "VRR (Adaptive Sync) will be turned on."
            ;;
        2)
            echo "VRR (Adaptive Sync) will be set to fullscreen only."
            ;;
        *)
            echo "Invalid option ($vrr_option). Skipping VRR configuration."
            ;;
    esac

    # Create a temporary file with the updated misc block
    tmpfile=$(mktemp)
    
    # Use awk to replace the vrr= line if it's already present, or append it if not
    awk -v vrr="$vrr_option" '/misc {/ {print; getline; if (!/vrr=/) print "        vrr=" vrr; else print "        vrr=" vrr; next} 1' ~/.config/hypr/conf/misc.conf > "$tmpfile"

    # Replace the original file with the temporary file
    mv "$tmpfile" ~/.config/hypr/conf/misc.conf
else
    echo "Skipping VRR configuration."
fi

    gum confirm "Do you want to rotate a monitor?"

if [ $? -eq 0 ]; then
    echo "Choose the rotation option:"
    rotation_option=$(gum choose --height 15 "normal (no transforms) -> 0" "90 degrees -> 1" "180 degrees -> 2" "270 degrees -> 3" "flipped -> 4" "flipped + 90 degrees -> 5" "flipped + 180 degrees -> 6" "flipped + 270 degrees -> 7")
    rotation_option="${rotation_option: -1}"  # Keep only the last character
    echo "Selected rotation option: $rotation_option"
    
    # Extract the last digit from the existing line
    current_rotation=$(sed -n "/^monitor=$selected_monitor/s/.*,\([0-9]\)$/\1/p" ~/.config/hypr/conf/monitors/default.conf)

    # Add your code here to apply the selected rotation option
    sed -i "/^monitor=$selected_monitor/s/$current_rotation$/,transform,$rotation_option/" ~/.config/hypr/conf/monitors/default.conf
else
    echo "No rotation will be applied."
fi

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
