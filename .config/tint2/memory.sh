#!/bin/sh

state="${XDG_RUNTIME_DIR:-/tmp}/tint2-memory"

case "$1" in
    toggle)
        if [ -f "$state" ]; then
            rm -f "$state"
        else
            : > "$state"
        fi
        exit 0
        ;;
esac

total=$(awk '/^MemTotal:/ {print $2}' /proc/meminfo)
free=$(awk '/^MemFree:/ {print $2}' /proc/meminfo)
buffers=$(awk '/^Buffers:/ {print $2}' /proc/meminfo)
cached=$(awk '/^Cached:/ {print $2}' /proc/meminfo)

used=$((total - free - buffers - cached))

if [ -f "$state" ]; then
    printf '  %s MiB\n' "$((used / 1024))"
else
     usage=$(( (used * 100 + total / 2) / total ))
    printf '  %s%%\n' "$usage"
fi
