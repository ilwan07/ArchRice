#!/usr/bin/env bash

USER=$(id -un)
MEDIA_DIR="/run/media/$USER"
declare -a MPOINTS

# 1) Collect only real mountpoints under /run/media/$USER
if [ -d "$MEDIA_DIR" ]; then
  for m in "$MEDIA_DIR"/*; do
    if mountpoint -q "$m"; then
      MPOINTS+=("$m")
    fi
  done
fi

# 2) If none, show nothing and exit
if [ ${#MPOINTS[@]} -eq 0 ]; then
  echo '{"text":""}'
  exit 0
fi

# 3) Build icon+count and newline‑delimited tooltip
icon="󱇰"
count=${#MPOINTS[@]}
text="${icon} ${count}"
tooltip=$(printf '%s\\n' "${MPOINTS[@]}")
tooltip=${tooltip%\\n}

# 4) Emit JSON for Waybar to parse
printf '{"text":"%s","tooltip":"%s"}' "$text" "$tooltip"
