_getModules() {
    clear

    local back="$(dirname "$1")"

    # Function to load a module
load_module() {
    local module_path="$1"
    for file in "$module_path/config.sh" "$module_path/module.sh"; do
        if [ -f "$file" ]; then
            source "$file" || { echo "ERROR: Failed to load $file in $module_path" && exit 1; }
        else
            echo "ERROR: $file does not exist in $module_path"
            exit 1
        fi
    done
}


    # Load the current module
    load_module "$1"

    # Read folder
    modules=($(find "$1" -maxdepth 1 -type d -not -name "*-custom" -not -name "*custom"))

    # Check if subfolders exist
    count=$((${#modules[@]} - 1))  # Subtract 1 to exclude the current directory

    # Create Navigation
    if ((count > 0)); then
        # Get modules folders
        modulesArr=()
        for value in "${modules[@]}"; do
            if [ -f "$value/config.sh" ]; then
                source "$value/config.sh" || { echo "ERROR: Failed to load config.sh in $value" && exit 1; }
                modulesArr+=("$order:$name:$value")
            else
                echo "ERROR: config.sh doesn't exist in $value"
                exit 1
            fi
        done

        # Sort array by order
        IFS=$'\n' modulesArr=($(sort <<<"${modulesArr[*]}"))
        unset nameList
        unset pathList

        # Output
        for value in "${modulesArr[@]}"; do
            name=$(cut -d':' -f2 <<<"$value")
            path=$(cut -d':' -f3 <<<"$value")
            nameList+=("$name")
            pathList+=("$path")

            # Check if init.sh exists in the module directory and execute it
            if [ -f "$path/init.sh" ]; then
                echo "Executing init.sh in $path"
                source "$path/init.sh"
            fi
        done
    fi
}

_getConfSelector() {
    local conf_file="$installFolder/conf/$1"
    local cur=$(basename "$(cat "$conf_file")")

    echo "Folder: $installFolder/conf/$2"
    echo "In use: $cur"
    echo ""

    echo "Select a file to load (RETURN = Confirm, ESC = Cancel/Back):"
    local sel=$(gum file "$conf_file")

    if [ -z "$sel" ]; then
        _goBack
    fi

    echo "File $(basename "$sel") selected."
    echo ""
}

_getConfEditor() {
    local selected
    local sel="$2"
    local filename

    selected=$(gum choose "EXECUTE" "EDIT" "COPY" "DELETE" "CANCEL")
    case $selected in
        EXECUTE)
            _writeConf "$1" "$sel"
            ;;
        EDIT)
            vim "$sel"
            sleep 1
            _reloadModule
            ;;
        COPY)
            echo "Define the new file name. Please use [a-zA-Z1-9_-]+.conf"
            filename=$(gum input --value="custom-${sel##*/}" --placeholder "Enter your filename")

            if [ -z "$filename" ]; then
                echo "ERROR: No filename specified."
            elif ! [[ "$filename" =~ ^[a-zA-Z1-9_-]+.conf ]]; then
                echo "ERROR: Wrong filename format. Please use [a-zA-Z1-9_-]+.conf"
            elif [ -f "$(dirname "$sel")/$filename" ]; then
                echo "ERROR: File already exists."
            else
                cp "$sel" "$(dirname "$sel")/$filename"
                _reloadModule
            fi
            _getConfEditor "$1" "$sel"
            ;;
        DELETE)
            if gum confirm "Do you really want to delete the file ${sel##*/}?" ; then
                rm "$sel"
                _reloadModule
            else
                _getConfEditor "$1" "$sel"
            fi
            ;;
        * )
            ;;
    esac
}

_writeConf() {
    local configFile="$installFolder/conf/$1"
    [ -n "$2" ] && echo "source = $(echo "$2" | sed "s+\/home\/$USER+~+")" > "$configFile"
}

# Return the version of the hyprland-settings script
_getVersion() {
    echo "$version"
}

# Write the header to a page
_getHeader() {
    figlet "$1"
    [ -n "$2" ] && echo "by $2"
    echo ""
}

# Update the breadcrumb and open the parent page
_goBack() {
    for _ in {1..4}; do unset clickArr[-1]; done
    _getModules "$back"
}

# Reload the current module
_reloadModule() {
    for _ in {1..2}; do unset clickArr[-1]; done
    _getModules "$current"
}

# Replace variables in a template and publish to a location
_replaceByTemplate() {
    local template=$1
    local variables=$2
    local values=$3
    local publishto=$4
    # Add your implementation here
}

# Back Button
_getBackBtn() {
    echo ""
    gum choose "Back"
    _goBack
}

# Repeat or go back
_getBackRepeatBtn() {
    echo ""
    selected=$(gum choose "REPEAT" "BACK")
    case $selected in
        BACK)
            _goBack
            ;;
        REPEAT)
            _getModules "$current"
            ;;
        * )
            ;;
    esac
}

# Install packages from a file
_installPackages() {
    local file_path=$1

    if [ -z "$file_path" ] || [ ! -f "$file_path" ]; then
        echo "ERROR: Please provide a valid file path."
        return 1
    fi

    while IFS= read -r pkg; do
        if pacman -Qs "$pkg" > /dev/null; then
            echo "The package $pkg is already installed."
        else
            echo "Installing $pkg"
            paru -S --noconfirm "$pkg"
        fi
    done < "$file_path"
}

