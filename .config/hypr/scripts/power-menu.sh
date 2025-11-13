#!/usr/bin/env bash

# 1) Define the menu order explicitly
MENU_ORDER=(Shutdown Reboot Lock)

# 2) Map each item to its command
declare -A ACTIONS=(
  [Shutdown]="poweroff"
  [Reboot]="reboot"
  [Lock]="hyprlock"
)

# 3) Pipe in the ordered list to wofi
choice=$(printf '%s\n' "${MENU_ORDER[@]}" \
         | wofi --dmenu --prompt "Power:")

# 4) If cancelled or empty, exit
[ -z "$choice" ] && exit 0

# 5) Execute the corresponding command
${ACTIONS[$choice]}
