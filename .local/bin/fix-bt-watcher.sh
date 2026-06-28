#!/usr/bin/env bash
# Polls once a second for the JBL's pactl card. Whenever it freshly appears
# (a connection event), waits for bluetoothd to settle on a profile, and if
# it picked HFP/HSP instead of A2DP, restarts WirePlumber + forces a
# reconnect — the sequence you confirmed fixes it.
set -uo pipefail

DEVICE_MAC="78:20:2E:18:9B:CE"
CARD="bluez_card.${DEVICE_MAC//:/_}"
POLL_INTERVAL=1
SETTLE_DELAY=1

get_active_profile() {
    pactl list cards 2>/dev/null | awk -v card="$CARD" '
        $0 ~ ("Name: " card) { found=1 }
        found && /Active Profile:/ { print $3; exit }
    '
}

fix_profile() {
    logger -t fix-bt "JBL landed on profile '$1' instead of A2DP, applying fix"
    systemctl --user restart wireplumber
    sleep 0.1
    bluetoothctl disconnect "$DEVICE_MAC"
    sleep 0.1
    bluetoothctl connect "$DEVICE_MAC"
}

was_present=false

while true; do
    profile=$(get_active_profile)

    if [[ -n "$profile" && "$was_present" == false ]]; then
        was_present=true
        sleep "$SETTLE_DELAY"
        profile=$(get_active_profile)
        [[ "$profile" != a2dp-sink* ]] && fix_profile "$profile"
    elif [[ -z "$profile" ]]; then
        was_present=false
    fi

    sleep "$POLL_INTERVAL"
done
