# ------------------------------------------------------
# Prepare hyprland-configuration-rootfs
# ------------------------------------------------------
echo -e "${GREEN}"
cat <<"EOF"
 ____                                 _   _             
|  _ \ _ __ ___ _ __   __ _ _ __ __ _| |_(_) ___  _ __  
| |_) | '__/ _ \ '_ \ / _` | '__/ _` | __| |/ _ \| '_ \ 
|  __/| | |  __/ |_) | (_| | | | (_| | |_| | (_) | | | |
|_|   |_|  \___| .__/ \__,_|_|  \__,_|\__|_|\___/|_| |_|
               |_|                                      

EOF
echo -e "${NONE}"
echo "Preparing temporary folders for the installation."
if [ ! -d ~/hyprland-configuration-rootfs-versions ]; then
    mkdir ~/hyprland-configuration-rootfs-versions
    echo "~/hyprland-configuration-rootfs-versions folder created."
fi
if [ ! -d ~/hyprland-configuration-rootfs-versions/$version ]; then
    mkdir ~/hyprland-configuration-rootfs-versions/$version
    echo "~/hyprland-configuration-rootfs-versions/$version folder created."
else
    echo "The folder ~/hyprland-configuration-rootfs-versions/$version already exists from previous installations."
    rm -rf ~/hyprland-configuration-rootfs-versions/$version
    mkdir ~/hyprland-configuration-rootfs-versions/$version
    echo "Clean build prepared for the installation."
fi
rsync -a -I --exclude-from=.install/excludes.txt . ~/hyprland-configuration-rootfs-versions/$version/
if [[ $(_isFolderEmpty ~/hyprland-configuration-rootfs-versions/$version/) == 0 ]] ;then
    echo "AN ERROR HAS OCCURED. Preparation of ~/hyprland-configuration-rootfs-versions/$version/ failed" 
    echo "Please check that rsync is installad on your system."
    echo "Execution of rsync -a -I --exclude-from=.install/excludes.txt . ~/hyprland-configuration-rootfs-versions/$version/ is required."
    exit
fi
if [ ! -f ~/hyprland-configuration-rootfs-versions/hook.sh ]; then
    # cp .install/templates/hook.sh ~/hyprland-configuration-rootfs-versions/ 
fi
echo "hyprland-configuration-rootfs $version successfully prepared in ~/hyprland-configuration-rootfs-versions/$version/"
echo ""
