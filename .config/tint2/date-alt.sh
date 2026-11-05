#!/bin/sh

state="${XDG_RUNTIME_DIR:-/tmp}/tint2-date-alt"

case "$1" in
    toggle)
        if [ -f "$state" ]; then
            rm -f "$state"
        else
            : > "$state"
        fi
        ;;
    *)
        if [ -f "$state" ]; then
            date '+%a, %b %d %Y'
        else
            date '+%H:%M'
        fi
        ;;
esac
