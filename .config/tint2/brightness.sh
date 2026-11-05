#!/bin/sh

base=/sys/class/backlight/intel_backlight

brightness=$(cat "$base/actual_brightness")
max=$(cat "$base/max_brightness")

percentage=$(( (brightness * 100 + max / 2) / max ))

printf '󰃠  %s%%\n' "$percentage"

