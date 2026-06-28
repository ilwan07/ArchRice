#!/bin/bash

# Auto-detect Hyprland instance signature if not already set
if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls /tmp/hypr/ 2>/dev/null | head -n1)
fi

# Bail out if Hyprland isn't running (e.g. at login before compositor starts)
[ -z "$HYPRLAND_INSTANCE_SIGNATURE" ] && exit 0

# Parse battery level and status
battery_info=$(acpi -b 2>/dev/null | head -n1)
battery_level=$(echo "$battery_info" | grep -oP '(?<=, )\d+(?=%)')
battery_status=$(echo "$battery_info" | grep -oP 'Battery \d+: \K\w+')

# Guard against empty output (no battery / acpi unavailable)
[ -z "$battery_level" ] && exit 0

# Only act when actually discharging
[ "$battery_status" != "Discharging" ] && exit 0

# Flag files, XDG_RUNTIME_DIR is /run/user/<uid>, always writable by your user
RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
FLAG_20="$RUNTIME_DIR/battery_notified_20"
FLAG_5="$RUNTIME_DIR/battery_notified_5"
FLAG_2="$RUNTIME_DIR/battery_notified_2"

# Clear flags as battery recovers above thresholds (e.g. after plugging in)
if [ "$battery_level" -gt 20 ]; then
    rm -f "$FLAG_20" "$FLAG_5" "$FLAG_2"
elif [ "$battery_level" -gt 5 ]; then
    rm -f "$FLAG_5" "$FLAG_2"
elif [ "$battery_level" -gt 2 ]; then
    rm -f "$FLAG_2"
fi

# Check thresholds, most critical first
if [ "$battery_level" -le 2 ]; then
    if [ ! -f "$FLAG_2" ]; then
        hyprctl notify 3 10000 0 fontsize:16 "WARNING: Battery critical! Suspending in 10 seconds..."
        touch "$FLAG_2"
        sleep 10
        systemctl suspend
    fi

elif [ "$battery_level" -le 5 ]; then
    if [ ! -f "$FLAG_5" ]; then
        hyprctl notify 0 10000 0 fontsize:16 "WARNING: Very low battery! 5% left!"
        touch "$FLAG_5"
    fi

elif [ "$battery_level" -le 20 ]; then
    if [ ! -f "$FLAG_20" ]; then
        hyprctl notify 0 10000 0 fontsize:16 "Warning: Low battery! 20% left."
        touch "$FLAG_20"
    fi
fi
