#!/bin/sh

x=${EXECP_X:-0}
y=${EXECP_Y:-0}
w=${EXECP_W:-0}
h=${EXECP_H:-0}

# Determine the long axis of the executor.
if [ "$h" -gt "$w" ]; then
    pos=$y
    size=$h
else
    pos=$x
    size=$w
fi

[ "$size" -gt 0 ] || exit 0

count=$(xprop -root _NET_NUMBER_OF_DESKTOPS 2>/dev/null |
    awk '{print $3}')

[ "$count" -gt 0 ] 2>/dev/null || exit 0

desktop=$((pos * count / size))

# Clamp, just in case the click lands exactly on the boundary.
[ "$desktop" -lt "$count" ] || desktop=$((count - 1))

wmctrl -s "$desktop"
