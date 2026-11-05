#!/bin/sh

xprop -root -spy \
    _NET_CURRENT_DESKTOP \
    _NET_NUMBER_OF_DESKTOPS \
    _NET_DESKTOP_NAMES \
    _NET_CLIENT_LIST |
    
awk '
function render(    i, n, name, out, info, desktop, state, clients, w) {

    if (count < 1 || names == "")
        return

    n = split(names, ws, /",[[:space:]]*"/)

    ws[1] = substr(ws[1], 2)
    ws[n] = substr(ws[n], 1, length(ws[n]) - 1)

    # Reset workspace states.
    for (i = 0; i < count; i++) {
        occupied[i] = 0
        urgent[i] = 0
    }

    # Check every client.
    n = split(client_list, clients, /,[[:space:]]*/)
    for (i = 1; i <= n; i++) {
        w = clients[i]

        cmd = "xprop -id " w " _NET_WM_DESKTOP _NET_WM_STATE 2>/dev/null"
        while ((cmd | getline line) > 0) {

            if (line ~ /_NET_WM_DESKTOP/) {
                sub(/^.*= /, "", line)
                desktop = line + 0
                occupied[desktop] = 1
            }

            if (line ~ /_NET_WM_STATE.*DEMANDS_ATTENTION/)
                urgent[desktop] = 1
        }

        close(cmd)
    }

    for (i = 0; i < count; i++) {

        if (i == current)
            print "<span line_height=\"1.5\">★</span>"
        else if (urgent[i])
            print "<span foreground=\"#FF0000\" line_height=\"1.5\">★</span>"
         else if (occupied[i])
            print "<span foreground=\"#000000\" line_height=\"1.5\">★</span>"
        else
            print "<span foreground=\"#000000\" line_height=\"1.5\">★</span>"

    }

    fflush()

}

/^_NET_CURRENT_DESKTOP/ {
    value = $0
    sub(/^.*= /, "", value)
    current = value + 0
    render()
    next
}

/^_NET_NUMBER_OF_DESKTOPS/ {
    value = $0
    sub(/^.*= /, "", value)
    count = value + 0
    next
}

/^_NET_DESKTOP_NAMES/ {
    value = $0
    sub(/^.*= /, "", value)
    names = value
    render()
    next
}

/^_NET_CLIENT_LIST/ {
    value = $0
    sub(/^.*# /, "", value)
    client_list = value
    render()
}
'
