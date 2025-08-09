#!/bin/bash

# Paths
CURSOR_CONF="$HOME/.config/hypr/cursor.conf"
CURRENT_WALLPAPER_FILE="$HOME/.cache/current_wallpaper.txt"

SOULBOUND_WALLPAPER="/home/leg/Downloads/e.png"
NORMAL_WALLPAPER="/home/leg/lightV.png"

# --- Cursor toggle ---

# Get current cursor theme from cursor.conf, fallback to empty if not found
CURRENT_CURSOR=$(grep "^env = XCURSOR_THEME" "$CURSOR_CONF" 2>/dev/null | cut -d',' -f2 | tr -d ' ' || echo "")

# Decide next cursor theme
if [[ "$CURRENT_CURSOR" == "Privateer-blender" ]]; then
    NEXT_CURSOR="Banana"
else
    NEXT_CURSOR="Privateer-blender"
fi

# Write new cursor config
{
  echo "env = XCURSOR_THEME, $NEXT_CURSOR"
  echo "env = XCURSOR_SIZE, 24"
  echo "env = XCURSOR_PATH, ~/.icons:/usr/share/icons"
} > "$CURSOR_CONF"

# Reload Hyprland config and set cursor immediately
hyprctl reload
hyprctl setcursor "$NEXT_CURSOR" 24


# --- Wallpaper toggle ---

# Kill existing swaybg to avoid multiple wallpapers
pkill swaybg 2>/dev/null

# Read current wallpaper path or assume normal if not cached
if [[ -f "$CURRENT_WALLPAPER_FILE" ]]; then
    CURRENT_WALLPAPER=$(cat "$CURRENT_WALLPAPER_FILE")
else
    CURRENT_WALLPAPER="$NORMAL_WALLPAPER"
fi

# Toggle wallpaper
if [[ "$CURRENT_WALLPAPER" == "$SOULBOUND_WALLPAPER" ]]; then
    NEW_WALLPAPER="$NORMAL_WALLPAPER"
else
    NEW_WALLPAPER="$SOULBOUND_WALLPAPER"
fi

# Start swaybg with new wallpaper
swaybg -i "$NEW_WALLPAPER" &

# Save new wallpaper path
echo "$NEW_WALLPAPER" > "$CURRENT_WALLPAPER_FILE"

# Notify user
notify-send "Theme toggled" "Cursor: $NEXT_CURSOR | Wallpaper changed."

