# ------------------------------------------------------
# Copy hyprland-configuration-rootfs
# ------------------------------------------------------
if [ ! -d ~/hyprland-configuration-rootfs ]; then
echo -e "${GREEN}"
cat <<"EOF"
 ___           _        _ _       _       _    __ _ _           
|_ _|_ __  ___| |_ __ _| | |   __| | ___ | |_ / _(_) | ___  ___ 
 | || '_ \/ __| __/ _` | | |  / _` |/ _ \| __| |_| | |/ _ \/ __|
 | || | | \__ \ || (_| | | | | (_| | (_) | |_|  _| | |  __/\__ \
|___|_| |_|___/\__\__,_|_|_|  \__,_|\___/ \__|_| |_|_|\___||___/
                                                                
EOF
echo -e "${NONE}"
else
echo -e "${GREEN}"
cat <<"EOF"
 _   _           _       _             _       _    __ _ _           
| | | |_ __   __| | __ _| |_ ___    __| | ___ | |_ / _(_) | ___  ___ 
| | | | '_ \ / _` |/ _` | __/ _ \  / _` |/ _ \| __| |_| | |/ _ \/ __|
| |_| | |_) | (_| | (_| | ||  __/ | (_| | (_) | |_|  _| | |  __/\__ \
 \___/| .__/ \__,_|\__,_|\__\___|  \__,_|\___/ \__|_| |_|_|\___||___/
      |_|                                                            

EOF
echo -e "${NONE}"
fi
if [ ! -d ~/hyprland-configuration-rootfs ]; then
echo "The script will now remove existing directories and files from ~/.config/"
echo "and copy your prepared configuration from ~/hyprland-configuration-rootfs-versions/$version to ~/hyprland-configuration-rootfs"
echo ""
echo "Symbolic links will then be created from ~/hyprland-configuration-rootfs into your ~/.config/ directory."
echo ""
fi
if [[ ! $(tty) == *"pts"* ]] && [ -d ~/hyprland-configuration-rootfs ]; then
    echo "You're running the script in tty. You can delete the existing ~/hyprland-configuration-rootfs folder now for a clean installation."
    echo "If not, the script will overwrite existing files but will not remove additional files or folders of your custom configuration."
    echo ""
else
    if [ -d ~/hyprland-configuration-rootfs ]; then
        echo "The script will overwrite existing files but will not remove additional files or folders of your custom configuration."
    fi
fi
if [ ! -d ~/hyprland-configuration-rootfs ]; then
    echo "PLEASE BACKUP YOUR EXISTING CONFIGURATIONS in .config IF NEEDED!"
    echo ""
fi

if gum confirm "Do you want to install the prepared hyprland-configuration-rootfs now?" ;then
    if [ ! $mode == "dev" ]; then
        echo "Copy started"
        if [ ! -d ~/hyprland-configuration-rootfs ]; then
            mkdir ~/hyprland-configuration-rootfs
            echo "~/hyprland-configuration-rootfs folder created."
        fi   
        rsync -a -I ~/hyprland-configuration-rootfs-versions/$version/ ~/hyprland-configuration-rootfs/
        if [[ $(_isFolderEmpty ~/hyprland-configuration-rootfs/) == 0 ]] ;then
            echo "AN ERROR HAS OCCURED. Copy prepared dofiles from ~/hyprland-configuration-rootfs-versions/$version/ to ~/hyprland-configuration-rootfs/ failed" 
            echo "Please check that rsync is installad on your system."
            echo "Execution of rsync -a -I ~/hyprland-configuration-rootfs-versions/$version/ ~/hyprland-configuration-rootfs/ is required."
            exit
        fi
        echo "All files from ~/hyprland-configuration-rootfs-versions/$version/ to ~/hyprland-configuration-rootfs/ copied."
    else
        echo "Skipped: DEV MODE!"
    fi
elif [ $? -eq 130 ]; then
        exit 130
else
    exit
fi
echo ""
