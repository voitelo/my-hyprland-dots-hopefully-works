#!/bin/bash

# Battery path (change if your system is different)
BAT_PATH="/sys/class/power_supply/BAT1"

# Thresholds
WARN_20=20
WARN_10=10
WARN_5=5

# Track if warnings were already sent
warned_20=0
warned_10=0
warned_5=0
shutdown_scheduled=0

while true; do
    if [ -d "$BAT_PATH" ]; then
        # Read battery capacity
        capacity=$(cat "$BAT_PATH/capacity")
        status=$(cat "$BAT_PATH/status")

        # Only warn if not charging
        if [[ "$status" != "Charging" && "$status" != "Full" ]]; then
            if (( capacity <= WARN_20 && warned_20 == 0 && capacity > WARN_10 )); then
                notify-send -u normal -t 10000 "Battery Warning" "Battery below 20% ($capacity%). Please consider charging."
                warned_20=1
            elif (( capacity <= WARN_10 && warned_10 == 0 && capacity > WARN_5 )); then
                notify-send -u critical -t 10000 "Battery Warning" "Battery below 10% ($capacity%). Charge immediately!"
                warned_10=1
            elif (( capacity <= WARN_5 && warned_5 == 0 )); then
                notify-send -u critical -t 20000 "Battery Critical" "Battery below 5% ($capacity%). System will shut down in 1 minute."
                warned_5=1

                # Schedule shutdown in 1 minute
                if (( shutdown_scheduled == 0 )); then
                    shutdown_scheduled=1
                    sudo shutdown -h +1 "Battery critically low. System shutting down."
                fi
            fi
        else
            # Reset warnings if charging or full
            warned_20=0
            warned_10=0
            warned_5=0
            shutdown_scheduled=0
        fi
    else
        notify-send -u low "Battery Monitor" "Battery path $BAT_PATH not found."
        exit 1
    fi

    sleep 60
done
