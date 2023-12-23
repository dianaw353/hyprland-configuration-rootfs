#!/bin/bash

figlet "Backups"

# Function to create a backup
_createBackup() {
    # Set source and destination directories
    source_dir="$HOME/.config"
    dest_dir="$HOME/dotfiles_backup"

    # Check if .config directory is empty
    if [ -z "$(ls -A $source_dir)" ]; then
        echo "No files found in $source_dir. Backup aborted."
        exit 1
    fi

    # Prompt user for confirmation to create a backup using Gum
    if gum confirm "There are files in $source_dir. Do you want to create a backup?"; then
        # Create destination directory if it doesn't exist
        mkdir -p "$dest_dir"

        # Create a subfolder with the day name, day number, and year along with the time
        backup_subfolder="$dest_dir/$(date +'%A_%d_%Y_@_%H%M%S')"
        mkdir -p "$backup_subfolder"

        # Copy .config files to the backup subfolder
        cp -r "$source_dir" "$backup_subfolder"

        # Notify user
        echo "Config files backed up successfully to $backup_subfolder"
    else
        echo "Backup aborted."
    fi
}

# Function to restore a previous backup
_restoreBackup() {
    # Check if dotfiles_backup directory is not empty
    if [ "$(ls -A $dest_dir)" ]; then
        # Display available backup subfolders using Gum filter
        echo "Please select your backup:"
        selected_backup=$(ls -1 "$dest_dir" | gum filter --placeholder "Please select your desired backup...")

        # Check if the selected backup exists
        if [ -d "$dest_dir/$selected_backup" ]; then
            # Add your restore logic here
            # For example, you can copy the contents of the selected backup back to the source directory.
            cp -r "$dest_dir/$selected_backup" "$HOME/.config"
            
            echo "Backup '$selected_backup' restored successfully to $HOME/.config"
        else
            echo "Invalid backup selection. Restoration aborted."
        fi
    else
        echo "No previous backups found in $dest_dir."
    fi
}

# Call the backup function
_createBackup

# Call the restore function
_restoreBackup
