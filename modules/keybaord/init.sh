#!/bin/bash

# Default layout and variants
figlet "Keyboard Conf"
kb_layout="us"

_setupKeyboardLayout() {
    echo ""
    echo "Start typing = Search, RETURN = Confirm, CTRL-C = Cancel"
    kb_layout=$(localectl list-x11-keymap-layouts | gum filter --height 15 --placeholder "Find your keyboard layout...")
    echo ""
    echo "Keyboard layout changed to $kb_layout"
    echo ""
    _confirmKeyboard
}
_confirmKeyboard() {
    echo "Current selected keyboard setup:"
    echo "Keyboard layout: $kb_layout"
    if gum confirm "Do you want proceed with this keyboard setup?" --affirmative "Proceed" --negative "Change" ;then
        SEARCH="kb_layout = .*"
        REPLACE="kb_layout = $kb_layout"
        sed -i "s/$SEARCH/$REPLACE/g" ~/hyprland-configuration-rootfs/modules/keybaord/templates/keyboard.conf
        cp ~/hyprland-configuration-rootfs/modules/keybaord/templates/keyboard.conf ~/.config/hypr/conf/keyboard.conf
        echo ""
        echo "Keyboard setup updated successfully."
        echo "PLEASE NOTE: You can update your keyboard layout later in ~/hyprland-configuration-rootfs/modules/keybaord/templates/keyboard.conf"
        return 0
    elif [ $? -eq 130 ]; then
        exit 130
    else
        _setupKeyboardLayout
    fi
}

if [ "$restored" == "1" ]; then
    echo "You have already restored your settings into the new installation."
else
    _setupKeyboardLayout
fi
