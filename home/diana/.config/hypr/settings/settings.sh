#!/bin/bash
_settingsDecoration() {
    clear
cat <<"EOF"
 ____                           _   _                 
|  _ \  ___  ___ ___  _ __ __ _| |_(_) ___  _ __  ___ 
| | | |/ _ \/ __/ _ \| '__/ _` | __| |/ _ \| '_ \/ __|
| |_| |  __/ (_| (_) | | | (_| | |_| | (_) | | | \__ \
|____/ \___|\___\___/|_|  \__,_|\__|_|\___/|_| |_|___/
                                                      
EOF
    cur=$(cat ~/dotfiles/hypr/conf/decoration.conf)
    echo "In use: ${cur##*/}"
    echo ""
    echo "Select a file to load (RETURN = Confirm, ESC = Cancel/Back):"
    sel=$(gum file ~/dotfiles/hypr/conf/decorations/)
    if [ ! -z $sel ] ;then
        sel=$(echo "$sel" | sed "s+"\/home\/$USER"+~+")
        echo "source = $sel" > ~/dotfiles/hypr/conf/decoration.conf
        _settingsDecoration
    fi
    _settingsMenu
}

_settingsWindow() {
    clear
cat <<"EOF"
__        ___           _                   
\ \      / (_)_ __   __| | _____      _____ 
 \ \ /\ / /| | '_ \ / _` |/ _ \ \ /\ / / __|
  \ V  V / | | | | | (_| | (_) \ V  V /\__ \
   \_/\_/  |_|_| |_|\__,_|\___/ \_/\_/ |___/
                                            
EOF
    cur=$(cat ~/dotfiles/hypr/conf/window.conf)
    echo "In use: ${cur##*/}"
    echo ""
    echo "Select a file to load (RETURN = Confirm, ESC = Cancel/Back):"
    sel=$(gum file ~/dotfiles/hypr/conf/windows/)
    if [ ! -z $sel ] ;then
        sel=$(echo "$sel" | sed "s+"\/home\/$USER"+~+")
        echo "source = $sel" > ~/dotfiles/hypr/conf/window.conf
        _settingsWindow
    fi
    _settingsMenu
}

_settingsAnimation() {
    clear
cat <<"EOF"
    _          _                 _   _                 
   / \   _ __ (_)_ __ ___   __ _| |_(_) ___  _ __  ___ 
  / _ \ | '_ \| | '_ ` _ \ / _` | __| |/ _ \| '_ \/ __|
 / ___ \| | | | | | | | | | (_| | |_| | (_) | | | \__ \
/_/   \_\_| |_|_|_| |_| |_|\__,_|\__|_|\___/|_| |_|___/
                                                       
EOF
    cur=$(cat ~/dotfiles/hypr/conf/animation.conf)
    echo "In use: ${cur##*/}"
    echo ""
    echo "Select a file to load (RETURN = Confirm, ESC = Cancel/Back):"
    sel=$(gum file ~/dotfiles/hypr/conf/animations/)
    if [ ! -z $sel ] ;then
        sel=$(echo "$sel" | sed "s+"\/home\/$USER"+~+")
        echo "source = $sel" > ~/dotfiles/hypr/conf/animation.conf
        _settingsAnimation
    fi
    _settingsMenu
}

_settingsMonitor() {
    clear
cat <<"EOF"
 __  __             _ _             
|  \/  | ___  _ __ (_) |_ ___  _ __ 
| |\/| |/ _ \| '_ \| | __/ _ \| '__|
| |  | | (_) | | | | | || (_) | |   
|_|  |_|\___/|_| |_|_|\__\___/|_|   
                                    
EOF
    cur=$(cat ~/dotfiles/hypr/conf/monitor.conf)
    echo "In use: ${cur##*/}"
    echo ""
    echo "Select a file to load (RETURN = Confirm, ESC = Cancel/Back):"
    
# Get the entire output of `hyprctl monitors`
output=$(hyprctl monitors)

# Count the number of monitors
count=$(echo "$output" | grep -c 'Monitor')

# Extract monitor names and IDs
monitors=$(echo "$output" | awk '/Monitor/ {name=$2} /ID/ {print name, $3}')

# Output the number of monitors and their names
echo "Currently there are $count monitors connected, their names are: $(echo "$monitors" | awk '{print $1}' | paste -sd ' ')"

# Prompt the user to select their initial screen resolution
echo "Please select your initial screen resolution. It can be changed later in ~/.config/hypr/hyprland.conf"
echo ""

# Set the same screen resolution for all monitors
for ((i=1; i<=$count; i++)); do
    # Get the name of the current monitor
    monitor_name=$(echo "$monitors" | awk -v i=$i '{if (NR==i) print $1}')

    # Display the name of the current monitor
    echo "Configuring monitor: $monitor_name"

    # Set the screen resolution for the current monitor
    screenres=$(gum choose --height 15 $(wlr-randr | grep -oP '\d{3,4}x\d{3,4}' | sort -u -n | tac))
    echo "$screenres"
    read -e -p "Choose a number to set the scale of the display (default 1): " -i "1" scaling
    if (( $scaling > 3 )); then
        read -e -p "Unsupported scale, Please choose a number between 1-3: " -i "1" scaling
    fi
    echo "$scaling"
    if grep -q "monitor=$monitor_name,.*,.*,.*" config.conf; then
        replace=$(echo "monitor=$monitor_name,$screenres,auto,$scaling")
        sed -i "s/monitor=$monitor_name,.*,.*,.*/$replace/g" config.conf
    else
        echo "monitor=$monitor_name,$screenres,auto,$scaling" >> config.conf
    fi

done

echo "Initial screen resolution set to $screenres"
echo "The display port that has been configured is: $(xrandr | grep -w connected | awk '{print $1}')"
echo "No more screens left to configure."
    read -n 1 -s -r -p "Press any key to continue:"
    _settingsMenu

    }

_settingsEnvironment() {
    clear
cat <<"EOF"
 _____            _                                      _   
| ____|_ ____   _(_)_ __ ___  _ __  _ __ ___   ___ _ __ | |_ 
|  _| | '_ \ \ / / | '__/ _ \| '_ \| '_ ` _ \ / _ \ '_ \| __|
| |___| | | \ V /| | | | (_) | | | | | | | | |  __/ | | | |_ 
|_____|_| |_|\_/ |_|_|  \___/|_| |_|_| |_| |_|\___|_| |_|\__|
                                                             
EOF

    cur=$(cat ~/dotfiles/hypr/conf/environment.conf)
    echo "In use: ${cur##*/}"
    echo ""
    echo "Please restart Hyprland after changing the environment."
    echo "If you select KVM it's recommended to shutdown your system and start again."
    echo ""
    echo "Select a file to load (RETURN = Confirm, ESC = Cancel/Back):"
    sel=$(gum file ~/dotfiles/hypr/conf/environments/)
    if [ ! -z $sel ] ;then
        sel=$(echo "$sel" | sed "s+"\/home\/$USER"+~+")
        echo "source = $sel" > ~/dotfiles/hypr/conf/environment.conf
    
    fi
    _settingsMenu
}

_settingsKeybinding() {
    clear
cat <<"EOF"
 _  __          _     _           _ _                 
| |/ /___ _   _| |__ (_)_ __   __| (_)_ __   __ _ ___ 
| ' // _ \ | | | '_ \| | '_ \ / _` | | '_ \ / _` / __|
| . \  __/ |_| | |_) | | | | | (_| | | | | | (_| \__ \
|_|\_\___|\__, |_.__/|_|_| |_|\__,_|_|_| |_|\__, |___/
          |___/                             |___/     

EOF
    cur=$(cat ~/dotfiles/hypr/conf/keybinding.conf)
    echo "In use: ${cur##*/}"
    echo ""
    echo "Select a file to load (RETURN = Confirm, ESC = Cancel/Back):"
    sel=$(gum file ~/dotfiles/hypr/conf/keybindings/)
    if [ ! -z $sel ] ;then
        sel=$(echo "$sel" | sed "s+"\/home\/$USER"+~+")
        echo "source = $sel" > ~/dotfiles/hypr/conf/keybinding.conf
    fi
    _settingsMenu
}

_settingsWindowrule() {
    clear
cat <<"EOF"
__        ___           _                          _           
\ \      / (_)_ __   __| | _____      ___ __ _   _| | ___  ___ 
 \ \ /\ / /| | '_ \ / _` |/ _ \ \ /\ / / '__| | | | |/ _ \/ __|
  \ V  V / | | | | | (_| | (_) \ V  V /| |  | |_| | |  __/\__ \
   \_/\_/  |_|_| |_|\__,_|\___/ \_/\_/ |_|   \__,_|_|\___||___/
                                                               
EOF

    cur=$(cat ~/dotfiles/hypr/conf/windowrule.conf)
    echo "In use: ${cur##*/}"
    echo ""
    echo "Select a file to load (RETURN = Confirm, ESC = Cancel/Back):"
    sel=$(gum file ~/dotfiles/hypr/conf/windowrules/)
    if [ ! -z $sel ] ;then
        sel=$(echo "$sel" | sed "s+"\/home\/$USER"+~+")
        echo "source = $sel" > ~/dotfiles/hypr/conf/windowrule.conf
    fi
    _settingsMenu
}

_settingsMenu() {
    clear
cat <<"EOF"
 ____       _   _   _                 
/ ___|  ___| |_| |_(_)_ __   __ _ ___ 
\___ \ / _ \ __| __| | '_ \ / _` / __|
 ___) |  __/ |_| |_| | | | | (_| \__ \
|____/ \___|\__|\__|_|_| |_|\__, |___/
                            |___/     

EOF
    if [ -f ~/dotfiles/version ] ;then
        echo "Version: $(cat ~/dotfiles/version)"
        echo ""
    fi
    menu=$(gum choose "Decorations" "Windows" "Animations" "Monitors" "Environments" "Keybindings" "Windowrules" "EXIT")
    case $menu in
        Decorations)
            _settingsDecoration
        break;;
        Windows) 
            _settingsWindow
        break;;
        Animations) 
            _settingsAnimation
        break;;
        Monitors) 
            _settingsMonitor
        break;;
        Environments) 
            _settingsEnvironment
        break;;
        Keybindings) 
            _settingsKeybinding
        break;;
        Windowrules) 
            _settingsWindowrule
        break;;
        * ) 
            exit
        ;;
    esac
}

_settingsMenu



