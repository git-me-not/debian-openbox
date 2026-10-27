#!/bin/bash

# Path to your Polybar config
CONFIG="$HOME/.config/polybar/config.ini"

# The line we want to edit
TARGET_LINE="modules-left"

# The two modules to toggle between
MODULE1="left2 launcher right2 xworkspaces"
MODULE2="left2 launcher right2 cmus playerctl"

# Find which one is currently active
if grep -q "$TARGET_LINE.*$MODULE1" "$CONFIG"; then
    # Replace module1 with module2
    sed -i "s/\($TARGET_LINE *= *\)$MODULE1/\1$MODULE2/" "$CONFIG"
    echo "Switched to $MODULE2"
else
    # Replace module2 with module1
    sed -i "s/\($TARGET_LINE *= *\)$MODULE2/\1$MODULE1/" "$CONFIG"
    echo "Switched to $MODULE1"
fi

# Reload Polybar
polybar-msg cmd restart
