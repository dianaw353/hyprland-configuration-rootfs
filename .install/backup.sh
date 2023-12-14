# ------------------------------------------------------
# Backup existing hyprland-configuration-rootfs
# ------------------------------------------------------

datets=$(date '+%Y%m%d%H%M%S')
if [ -d ~/hyprland-configuration-rootfs ] || [ -f ~/.zshrc ]; then
echo -e "${GREEN}"
cat <<"EOF"
____             _                
| __ )  __ _  ___| | ___   _ _ __  
|  _ \ / _` |/ __| |/ / | | | '_ \ 
| |_) | (_| | (__|   <| |_| | |_) |
|____/ \__,_|\___|_|\_\\__,_| .__/ 
                            |_|    

EOF
echo -e "${NONE}"
    if [ -d ~/hyprland-configuration-rootfs ]; then
        echo "The script has detected an existing hyprland-configuration-rootfs folder and will try to create a backup into the folder:"
        echo "~/hyprland-configuration-rootfs-versions/backups/$datets"
    fi
    if [ ! -L ~/.zshrc ] && [ -f ~/.zshrc ]; then
        echo "The script has detected an existing .zshrc file and will try to create a backup to:" 
        echo "~/hyprland-configuration-rootfs-versions/backups/$datets/.zshrc-old"
    fi
    if gum confirm "Do you want to create a backup?" ;then
        if [ ! -d ~/hyprland-configuration-rootfs-versions ]; then
            mkdir ~/hyprland-configuration-rootfs-versions
            echo "~/hyprland-configuration-rootfs-versions created."
        fi
        if [ ! -d ~/hyprland-configuration-rootfs-versions/backups ]; then
            mkdir ~/hyprland-configuration-rootfs-versions/backups
            echo "~/hyprland-configuration-rootfs-versions/backups created"
        fi
        if [ ! -d ~/hyprland-configuration-rootfs-versions/backups/$datets ]; then
            mkdir ~/hyprland-configuration-rootfs-versions/backups/$datets
            echo "~/hyprland-configuration-rootfs-versions/backups/$datets created"
        fi
        if [ -d ~/hyprland-configuration-rootfs ]; then
            rsync -a ~/hyprland-configuration-rootfs/ ~/hyprland-configuration-rootfs-versions/backups/$datets/
            echo "Backup of your current hyprland-configuration-rootfs in ~/hyprland-configuration-rootfs-versions/backups/$datets created."
        fi
        if [ -f ~/.zshrc ]; then
            cp ~/.zshrc ~/hyprland-configuration-rootfs-versions/backups/$datets/.zshrc-old
            echo "Existing .zshrc file found in homefolder. .zshrc-old created"
        fi
    elif [ $? -eq 130 ]; then
        exit 130
    else
        echo "Backup skipped."
    fi
    echo ""
fi
