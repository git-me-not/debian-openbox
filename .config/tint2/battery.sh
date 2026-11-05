#!/bin/sh

base=/sys/class/power_supply/BAT1

capacity=$(cat "$base/capacity")
status=$(cat "$base/status")

if [ "$status" = "Charging" ]; then
    printf '  %s%% 󱐋\n' "$capacity"
else
    printf '  %s%%\n' "$capacity"
fi
