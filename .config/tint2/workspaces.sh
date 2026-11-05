#!/bin/sh

if [ "$1" = glyph ]; then
    mode=glyph
else
    mode=name
fi

xprop -root -spy \
    _NET_CURRENT_DESKTOP \
    _NET_NUMBER_OF_DESKTOPS \
    _NET_DESKTOP_NAMES \
    _NET_CLIENT_LIST |
    
awk -v mode="$mode" '
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

#
# glyph mode
#
	if (mode == "glyph") {
    out = ""

    for (i = 0; i < count; i++) {

        if (i == current)
			out = out "★"	
        else if (urgent[i])
            out = out "<span foreground=\"#FF0000\">★</span>"
         else if (occupied[i])
            out = out "★"
        else
            out = out "<span foreground=\"#000000\">★</span>"

		 if (i < count - 1)
            out = out "  "
            
    }

	print out
    fflush()
    return

}

#
# name mode   out = out " " name " " "</span>"  "<span foreground=\"#FF0000\">★</span>"
#
    out = ""

    for (i = 0; i < count; i++) {
        name = ws[i + 1]

		if (urgent[i])
            out = out " " name " "  "<span foreground=\"#FF0000\">★</span>"
        else if (i == current)
            out = out " " name " " "★"
         else if (occupied[i])
            out = out " " name " " "<span foreground=\"#FDFDFD\">★</span>"
        else
            out = out "<span foreground=\"#000000\"> " name "</span>" "<span foreground=\"#FDFDFD\">★</span>"

        if (i < count - 1)
            out = out "   "
    }

    print out
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
