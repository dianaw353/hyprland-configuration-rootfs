#!/bin/sh
figlet "Network"
# Function to connect to the network
connect_to_network() {
    # Start the spinner
    gum spin --spinner dot --title "Scanning for networks..." -- sleep 5 &

    # Get the list of WiFi networks
    ssid=$(nmcli --fields "SSID" device wifi list | tail -n +2 | grep -v -- '--')

    # If there are any networks, stop the spinner and print the networks
    if [ -n "$ssid" ]; then
        echo "Select Wifi Network:"
        ssid=$(echo "$ssid" | gum filter --placeholder "Please select your WIFI newtwork...")
    fi

    # Trim leading and trailing spaces from the SSID
    ssid=$(echo "$ssid" | xargs)

    # Echo asking for the network password
    echo "Please enter your password for $ssid:"

    # Prompt for the network password
    password=$(gum input --password --placeholder "Password:")

    # Start the spinner
    gum spin --spinner dot --title "Connecting to WiFi..." -- sleep 2 &

    # Try to connect to the network
    if nmcli device wifi connect "$ssid" password "$password" &> /dev/null; then
        echo "Successfully connected to $ssid!"
    else
        echo "Failed to connect to $ssid. Please check your password and try again."
        exit 1
    fi
}

connect_to_network
