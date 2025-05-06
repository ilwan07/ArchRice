#!/usr/bin/env bash

USER=$(id -un)

# 1) Gather current mount points under /run/media/$USER
mapfile -t MPOINTS < <(
  lsblk -nr -o MOUNTPOINT,NAME \
  | grep "^/run/media/$USER" \
  | awk '{print $1}'
)

# 2) If none, exit
[ ${#MPOINTS[@]} -eq 0 ] && exit 0

# 3) Let user pick one via wofi in dmenu mode
choice=$(printf "%s\n" "${MPOINTS[@]}" \
         | wofi --dmenu --prompt "Unmount")

# 4) If canceled, exit
[ -z "$choice" ] && exit 0

# 5) Find block device for the chosen mountpoint
DEV=$(lsblk -nr -o PATH,MOUNTPOINT \
      | awk -v m="$choice" '$2==m{print $1}')

# 6) Unmount safely with udisksctl (no sudo needed)
udisksctl unmount -b "$DEV"
