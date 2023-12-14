# ------------------------------------------------------
# Restore
# ------------------------------------------------------

restorelist=""
selectedlist=""
monitorrestored=0

_showRestoreOptions() {
    echo "The following configurations can be transferred into the new installation."
    echo "(SPACE = select/unselect a profile. RETURN = confirm. No selection = CANCEL)"
    echo ""
    restorelist=""
    if [ -f ~/hyprland-configuration-rootfs/.zshrc ]; then
        restorelist+="~/hyprland-configuration-rootfs/.zshrc "
        selectedlist+="~/hyprland-configuration-rootfs/.zshrc,"
    fi
    if [ -d ~/hyprland-configuration-rootfs/.settings ]; then
        restorelist+="~/hyprland-configuration-rootfs/.settings "
        selectedlist+="~/hyprland-configuration-rootfs/.settings,"
    fi
    if [[ $profile == *"Hyprland"* ]]; then
        if [ -f ~/hyprland-configuration-rootfs/hypr/conf/custom.conf ]; then
            restorelist+="~/hyprland-configuration-rootfs/hypr/conf/custom.conf "
            selectedlist+="~/hyprland-configuration-rootfs/hypr/conf/custom.conf,"
        fi
        if [ -f ~/hyprland-configuration-rootfs/hypr/conf/keyboard.conf ]; then
            restorelist+="~/hyprland-configuration-rootfs/hypr/conf/keyboard.conf "
            selectedlist+="~/hyprland-configuration-rootfs/hypr/conf/keyboard.conf,"
        fi
        if [ -f ~/hyprland-configuration-rootfs/hypr/conf/keybinding.conf ] && [ -d ~/hyprland-configuration-rootfs/hypr/conf/keybindings/ ]; then
            restorelist+="~/hyprland-configuration-rootfs/hypr/conf/keybinding.conf "
            selectedlist+="~/hyprland-configuration-rootfs/hypr/conf/keybinding.conf,"
        fi
        if [ -f ~/hyprland-configuration-rootfs/hypr/conf/environment.conf ] && [ -d ~/hyprland-configuration-rootfs/hypr/conf/environments/ ]; then
            restorelist+="~/hyprland-configuration-rootfs/hypr/conf/environment.conf "
            selectedlist+="~/hyprland-configuration-rootfs/hypr/conf/environment.conf,"
        fi
        if [ -f ~/hyprland-configuration-rootfs/hypr/conf/windowrule.conf ] && [ -d ~/hyprland-configuration-rootfs/hypr/conf/windowrules/ ]; then
            restorelist+="~/hyprland-configuration-rootfs/hypr/conf/windowrule.conf "
            selectedlist+="~/hyprland-configuration-rootfs/hypr/conf/windowrule.conf,"
        fi
        if [ -f ~/hyprland-configuration-rootfs/hypr/conf/monitor.conf ] && [ -d ~/hyprland-configuration-rootfs/hypr/conf/monitors/ ]; then
            restorelist+="~/hyprland-configuration-rootfs/hypr/conf/monitor.conf "
            selectedlist+="~/hyprland-configuration-rootfs/hypr/conf/monitor.conf,"
            monitorrestored=1
        fi
        if [ -f ~/hyprland-configuration-rootfs/hypr/conf/animation.conf ] && [ -d ~/hyprland-configuration-rootfs/hypr/conf/animations/ ]; then
            restorelist+="~/hyprland-configuration-rootfs/hypr/conf/animation.conf "
            selectedlist+="~/hyprland-configuration-rootfs/hypr/conf/animation.conf,"
        fi
        if [ -f ~/hyprland-configuration-rootfs/hypr/conf/decoration.conf ] && [ -d ~/hyprland-configuration-rootfs/hypr/conf/decorations/ ]; then
            restorelist+="~/hyprland-configuration-rootfs/hypr/conf/decoration.conf "
            selectedlist+="~/hyprland-configuration-rootfs/hypr/conf/decoration.conf,"
        fi
        if [ -f ~/hyprland-configuration-rootfs/hypr/conf/window.conf ] && [ -d ~/hyprland-configuration-rootfs/hypr/conf/windows/ ]; then
            restorelist+="~/hyprland-configuration-rootfs/hypr/conf/window.conf "
            selectedlist+="~/hyprland-configuration-rootfs/hypr/conf/window.conf,"
        fi
    fi
    if [[ $profile == *"Qtile"* ]]; then
        if [ -f ~/hyprland-configuration-rootfs/qtile/conf/keyboard.py ]; then
            restorelist+="~/hyprland-configuration-rootfs/qtile/conf/keyboard.py "
            selectedlist+="~/hyprland-configuration-rootfs/qtile/conf/keyboard.py,"
        fi
        if [ -f ~/hyprland-configuration-rootfs/qtile/autostart_wayland.sh ]; then
            restorelist+="~/hyprland-configuration-rootfs/qtile/autostart_wayland.sh "
            selectedlist+="~/hyprland-configuration-rootfs/qtile/autostart_wayland.sh,"
        fi
        if [ -f ~/hyprland-configuration-rootfs/qtile/autostart_x11.sh ]; then
            restorelist+="~/hyprland-configuration-rootfs/qtile/autostart_x11.sh "
            selectedlist+="~/hyprland-configuration-rootfs/qtile/autostart_x11.sh,"
        fi
    fi
    restoreselect=$(gum choose --no-limit --height 20 --cursor-prefix "( ) " --selected-prefix "(x) " --unselected-prefix "( ) " --selected="$selectedlist" $restorelist)
    if [ ! -z "$restoreselect" ] ;then
        echo "Selected to restore:" 
        echo "$restoreselect"
        echo ""
        confirmrestore=$(gum choose "Start restore" "Change restore" "Cancel restore")
        if [ "$confirmrestore" == "Start restore" ] ;then
            _startRestore
        elif [ "$confirmrestore" == "Change restore" ]; then 
            _showRestoreOptions
        else
            echo "Restore skipped."
            return 0
        fi
    else
        echo "No files selected to restore."
        confirmrestore=$(gum choose "Change restore" "Cancel restore")
        if [ "$confirmrestore" == "Change restore" ]; then 
            echo ""
            _showRestoreOptions
        else
            echo "Restore skipped."
            return 0
        fi
    fi
}

_startRestore() {
    if [[ $restoreselect == *"~/hyprland-configuration-rootfs/.zshrc"* ]] || [[ $restoreselect == *"All"* ]] ; then
        if [ -f ~/hyprland-configuration-rootfs/.zshrc ]; then
            cp ~/hyprland-configuration-rootfs/.zshrc ~/hyprland-configuration-rootfs-versions/$version/
            echo ".zshrc restored!"
        fi
    fi
    if [[ $restoreselect == *"~/hyprland-configuration-rootfs/.settings"* ]] || [[ $restoreselect == *"All"* ]] ; then
        if [ -d ~/hyprland-configuration-rootfs/.settings ]; then
            rsync -a -I ~/hyprland-configuration-rootfs/.settings/ ~/hyprland-configuration-rootfs-versions/$version/.settings/
            echo ".settings restored!"
        fi
    fi
    if [[ $profile == *"Hyprland"* ]]; then
        if [[ $restoreselect == *"~/hyprland-configuration-rootfs/hypr/conf/custom.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/hyprland-configuration-rootfs/hypr/conf/custom.conf ]; then
                cp ~/hyprland-configuration-rootfs/hypr/conf/custom.conf ~/hyprland-configuration-rootfs-versions/$version/hypr/conf/
                echo "Hyprland custom.conf restored!"
            fi
        fi
        if [[ $restoreselect == *"~/hyprland-configuration-rootfs/hypr/conf/keyboard.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/hyprland-configuration-rootfs/hypr/conf/keyboard.conf ]; then
                cp ~/hyprland-configuration-rootfs/hypr/conf/keyboard.conf ~/hyprland-configuration-rootfs-versions/$version/hypr/conf/
                echo "Hyprland keyboard.conf restored!"
            fi
        fi        
        if [[ $restoreselect == *"~/hyprland-configuration-rootfs/hypr/conf/monitor.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/hyprland-configuration-rootfs/hypr/conf/monitor.conf ]; then
                cp ~/hyprland-configuration-rootfs/hypr/conf/monitor.conf ~/hyprland-configuration-rootfs-versions/$version/hypr/conf/
                echo "Hyprland monitor.conf restored!"                
            fi
        fi
        if [[ $restoreselect == *"~/hyprland-configuration-rootfs/hypr/conf/keybinding.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/hyprland-configuration-rootfs/hypr/conf/keybinding.conf ]; then
                cp ~/hyprland-configuration-rootfs/hypr/conf/keybinding.conf ~/hyprland-configuration-rootfs-versions/$version/hypr/conf/
                echo "Hyprland keybinding.conf restored!"
            fi
        fi
        if [[ $restoreselect == *"~/hyprland-configuration-rootfs/hypr/conf/environment.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/hyprland-configuration-rootfs/hypr/conf/environment.conf ]; then
                cp ~/hyprland-configuration-rootfs/hypr/conf/environment.conf ~/hyprland-configuration-rootfs-versions/$version/hypr/conf/
                echo "Hyprland environment.conf restored!"
            fi
        fi        
        if [[ $restoreselect == *"~/hyprland-configuration-rootfs/hypr/conf/windowrule.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/hyprland-configuration-rootfs/hypr/conf/windowrule.conf ]; then
                cp ~/hyprland-configuration-rootfs/hypr/conf/windowrule.conf ~/hyprland-configuration-rootfs-versions/$version/hypr/conf/
                echo "Hyprland windowrule.conf restored!"
            fi
        fi        
        if [[ $restoreselect == *"~/hyprland-configuration-rootfs/hypr/conf/animation.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/hyprland-configuration-rootfs/hypr/conf/animation.conf ]; then
                cp ~/hyprland-configuration-rootfs/hypr/conf/animation.conf ~/hyprland-configuration-rootfs-versions/$version/hypr/conf/
                echo "Hyprland animation.conf restored!"
            fi
        fi
        if [[ $restoreselect == *"~/hyprland-configuration-rootfs/hypr/conf/decoration.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/hyprland-configuration-rootfs/hypr/conf/decoration.conf ]; then
                cp ~/hyprland-configuration-rootfs/hypr/conf/decoration.conf ~/hyprland-configuration-rootfs-versions/$version/hypr/conf/
                echo "Hyprland decoration.conf restored!"
            fi
        fi
        if [[ $restoreselect == *"~/hyprland-configuration-rootfs/hypr/conf/window.conf"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/hyprland-configuration-rootfs/hypr/conf/window.conf ]; then
                cp ~/hyprland-configuration-rootfs/hypr/conf/window.conf ~/hyprland-configuration-rootfs-versions/$version/hypr/conf/
                echo "Hyprland window.conf restored!"
            fi
        fi
    fi
    if [[ $profile == *"Qtile"* ]]; then
        if [[ $restoreselect == *"~/hyprland-configuration-rootfs/qtile/conf/keyboard.py"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/hyprland-configuration-rootfs/qtile/conf/keyboard.py ]; then
                cp ~/hyprland-configuration-rootfs/qtile/conf/keyboard.py ~/hyprland-configuration-rootfs-versions/$version/qtile/conf/
                echo "Qtile keyboard.py restored!"
            fi
        fi
        if [[ $restoreselect == *"~/hyprland-configuration-rootfs/qtile/autostart_wayland.sh"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/hyprland-configuration-rootfs/qtile/autostart_wayland.sh ]; then
                cp ~/hyprland-configuration-rootfs/qtile/autostart_wayland.sh ~/hyprland-configuration-rootfs-versions/$version/qtile/
                echo "Qtile autostart_wayland.sh restored!"
            fi
        fi
        if [[ $restoreselect == *"~/hyprland-configuration-rootfs/qtile/autostart_x11.sh"* ]] || [[ $restoreselect == *"All"* ]] ; then
            if [ -f ~/hyprland-configuration-rootfs/qtile/autostart_x11.sh ]; then
                cp ~/hyprland-configuration-rootfs/qtile/autostart_x11.sh ~/hyprland-configuration-rootfs-versions/$version/qtile/
                echo "Qtile autostart_x11.sh restored!"
            fi
        fi
    fi
    restored=1
    return 0
}

if [ -d ~/hyprland-configuration-rootfs ]; then

echo -e "${GREEN}"
cat <<"EOF"
 ____           _                 
|  _ \ ___  ___| |_ ___  _ __ ___ 
| |_) / _ \/ __| __/ _ \| '__/ _ \
|  _ <  __/\__ \ || (_) | | |  __/
|_| \_\___||___/\__\___/|_|  \___|
                                  
EOF
echo -e "${NONE}"
    restored=0
    echo "The script will try to restore existing configurations."
    echo "PLEASE NOTE: Restoring is not possible with version < 2.5 of the hyprland-configuration-rootfs."
    echo "In that case, please use the automated backup or create your own backup manually."
    echo ""
    
    _showRestoreOptions
    
    echo ""
fi
