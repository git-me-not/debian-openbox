#!/bin/sh

for iface in /sys/class/net/*; do
    iface=${iface##*/}

    [ "$iface" = "lo" ] && continue

    # Wi-Fi
    if [ -d "/sys/class/net/$iface/wireless" ]; then
        state=$(cat "/sys/class/net/$iface/operstate" 2>/dev/null)

        if [ "$state" = "up" ]; then
            ssid=$(/sbin/iw dev "$iface" link 2>/dev/null |
                sed -n 's/^[[:space:]]*SSID: //p')

            if [ -n "$ssid" ]; then
                printf '󰖩 %s\n' "$ssid"
            else
                printf '󰖪  <span foreground="#000000">disconnected</span>\n'
            fi
        else
            printf '󰖪  <span foreground="#000000">disconnected</span>\n'
        fi

        exit
    fi

    # Ethernet
    state=$(cat "/sys/class/net/$iface/operstate" 2>/dev/null)

    if [ "$state" = "up" ]; then
        printf '󰈀  %s\n' "$iface"
        exit
    fi
done

printf '󰖪  <span foreground="#000000">disconnected</span>\n'
