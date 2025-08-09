#!/bin/bash

# === Simple Arch Hyprland Restore Script (Safer Version) ===

if [[ "$(basename "$PWD")" != "my-hyprland-dots" ]]; then
    echo "❌ You must be in the 'my-hyprland-dots' folder to run this script."
    echo "Current directory: $PWD"
    exit 1
fi

# Helper function for yes/no questions
ask() {
    read -rp "$1 (y/n): " ans
    [[ "$ans" == "y" || "$ans" == "Y" ]]
}

# Backup function
backup_if_exists() {
    local target="$1"
    if [[ -e "$target" ]]; then
        local backup="${target}.bak.$(date +%Y%m%d%H%M%S)"
        echo "📦 Backing up $target -> $backup"
        sudo cp -r "$target" "$backup"
    fi
}

echo "=== Arch Hyprland Restore Script ==="

# Update system
if ask "Do you want to update your system?"; then
    sudo pacman -Syu
fi

# Install packages
PACKAGES=(fastfetch waybar hyprlock flatpak emote wine)
if ask "Do you want to install your package list?"; then
    sudo pacman -S --needed "${PACKAGES[@]}"
fi

# Kitty config
if ask "Do you want to restore Kitty config?"; then
    mkdir -p ~/.config/kitty
    cp config/kitty.conf ~/.config/kitty/
fi

# Fastfetch config
if ask "Do you want to restore Fastfetch config?"; then
    mkdir -p ~/.config/fastfetch
    cp -r config/fastfetch/* ~/.config/fastfetch/
fi

# Dunst config
if ask "Do you want to restore Dunst config?"; then
    backup_if_exists /etc/dunst/dunstrc
    sudo mkdir -p /etc/dunst
    sudo cp config/dunstrc /etc/dunst/dunstrc
fi

# Waybar config
if ask "Do you want to restore Waybar config?"; then
    backup_if_exists /etc/xdg/waybar
    sudo mkdir -p /etc/xdg/waybar
    sudo cp -r config/waybar/* /etc/xdg/waybar/
fi

# Hyprland config
if ask "Do you want to restore Hyprland config?"; then
    backup_if_exists ~/.config/hypr
    mkdir -p ~/.config/hypr
    cp -r config/hypr/* ~/.config/hypr/
fi

# Hyprland Scripts folder
if ask "Do you want to restore your old Hyprland Scripts folder?"; then
    mkdir -p ~/Scripts
    cp -r config/Scripts/* ~/Scripts/
fi

# old .bashrc file
if ask "Do you want to restore your old bashrc file?"; then
    backup_if_exists ~/.bashrc
    cp config/.bashrc ~/
fi

echo "=== ✅ Restore Complete! ==="
