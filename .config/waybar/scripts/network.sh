#!/bin/sh

figlet Network

# Function to connect to the network
connect_to_network() {
    # Get the list of WiFi networks
    echo "scanning for networks... please wait"
    ssid=$(nmcli --fields "SSID" device wifi list | grep -v -- '--' | tail -n +2 | gum filter --placeholder "Please select your WIFI newtwork...")

    # Trim leading and trailing spaces from the SSID
    ssid=$(echo "$ssid" | xargs)

    while true; do
        # Prompt for the network password
        echo "Please enter your password for $ssid:"
        password=$(gum input --password --placeholder "Please type in password for $ssid")

        # Try to connect to the network
        if nmcli device wifi connect "$ssid" password "$password"; then
            echo "Successfully connected to $ssid!"
            break
        else
            echo "Failed to connect to $ssid. Please check your password and try again."
            echo "Do you want to try again? (yes/no)"
            read answer
            if [ "$answer" != "${answer#[Nn]}" ] ;then
                break
            fi
        fi
    done
}

connect_to_network


