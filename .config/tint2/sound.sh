#!/bin/sh

volume=$(pactl get-sink-volume @DEFAULT_SINK@ |
    sed -n 's/.* \([0-9]\{1,3\}\)%.*$/\1/p' |
    head -n 1)

mute=$(pactl get-sink-mute @DEFAULT_SINK@ |
    awk '{print $2}')

if [ "$mute" = "yes" ]; then
    printf '<span foreground="#000000">muted</span>\n'
else
    printf '󰕾 %s%%\n' "$volume"
fi
