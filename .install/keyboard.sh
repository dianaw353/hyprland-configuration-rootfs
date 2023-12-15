_setupkeyboardlayout() {
    echo -e "${GREEN}"
    figlet "Keyboard"
    echo -e "${NONE}"
    echo "start typing = search, return = confirm, ctrl-c = cancel"
    keyboard_layout=$(localectl list-x11-keymap-layouts | gum filter --height 15 --placeholder "find your keyboard layout...")
    echo ""
    echo "keyboard layout changed to $keyboard_layout"
    echo ""
    _confirmkeyboard
}

_confirmkeyboard() {
    echo "current selected keyboard setup:"
    echo "keyboard layout: $keyboard_layout"
    if gum confirm "do you want proceed with this keyboard setup?" --affirmative "proceed" --negative "change" ;then
        return 0
    elif [ $? -eq 130 ]; then
        exit 130
    fi
}

