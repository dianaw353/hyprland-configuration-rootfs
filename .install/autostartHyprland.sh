_autostartHyprland() {
    echo -e "${GREEN}"
    figlet "Autostart"
    echo -e "${NONE}"
    # Ask the user if they want to autostart Hyprland at bootup
    read -p "Do you want to autostart Hyprland at bootup? (y/n) " answer

    # If the user answers "yes", enable autologin and use the .zsh/.bash script to autostart Hyprland
    if [[ $answer == "y" ]]; then
        # Replace ADD_USERNAME_HERE with the output of the `whoami` command
        sed -i "s/diana/$(whoami)/g" etc/systemd/system/getty@tty1.service
        sudo systemctl enable getty@tty1.service
        echo "Hyprland will now autostart at bootup."
    else
        echo "Hyprland will not autostart at bootup."
    fi > /etc/systemd/system/getty@tty1.service
}

