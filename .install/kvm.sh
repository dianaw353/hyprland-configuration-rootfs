# kvm_settings.sh

# Function to check if KVM is running
_isKVM() {
    if [ -n "$(sudo dmesg | grep -i kvm)" ]; then
        echo 0  # '0' means 'true' in Bash
    else
        echo 1  # '1' means 'false' in Bash
    fi
}

# Function to set KVM environment variables
_setupKVMEnvironment() {
    if [ $(_isKVM) == "0" ] ;then
        echo -e "${GREEN}"
        figlet "KVM VM"
        echo -e "${NONE}"
        if gum confirm "Are you running this script in a KVM virtual machine?" ;then
            SEARCH="# env = WLR_NO_HARDWARE_CURSORS"
            REPLACE="env = WLR_NO_HARDWARE_CURSORS"
            sed -i -e "s/$SEARCH/$REPLACE/g" ~/.config/hypr/hyprland.conf

            SEARCH="# env = WLR_RENDERER_ALLOW_SOFTWARE"
            REPLACE="env = WLR_RENDERER_ALLOW_SOFTWARE"
            sed -i -e "s/$SEARCH/$REPLACE/g" ~/.config/hypr/hyprland.conf

            echo "Environment cursor settings set to KVM."
        fi
    fi
}
