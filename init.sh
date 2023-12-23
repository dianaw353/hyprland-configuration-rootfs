ptfiglet "Dotfiles Installation"
echo "Installing Dotfiles"

if gum confirm "DO YOU WANT TO COPY THE PREPARED dotfiles INTO .config? (YOU CAN ALSO DO THIS MANUALLY)" ; then
    rsync -a -I ~/Hyprland-Starter/alacritty ~/.config
    rsync -a -I ~/Hyprland-Starter/hypr ~/.config
    rsync -a -I ~/Hyprland-Starter/swaylock ~/.config
    rsync -a -I ~/Hyprland-Starter/mako ~/.config
    echo ""
    echo ":: Configuration files successfully copied to ~/.config/"
    echo ""
    echo "Enabling system to execute scripts"
    chmod +x ~/.config/hypr/scripts/*
elif [ $? -eq 130 ]; then
    exit 130
else
    echo ""
    echo "Installation canceled."
    echo "PLEASE NOTE: Open ~/.config/hypr/hyprland.conf to change your keyboard layout (default is us) and your screen resolution (default is preferred) if needed."
    echo "Then reboot your system!"
    exit;
fi

