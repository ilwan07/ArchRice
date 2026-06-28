#!/bin/bash
# Permanently delete items trashed more than N days ago.

TRASH_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/Trash"
INFO_DIR="$TRASH_DIR/info"
FILES_DIR="$TRASH_DIR/files"
MAX_DAYS="${1:-14}"
LOG_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/trash-cleanup.log"

now=$(date +%s)
cutoff=$(( now - MAX_DAYS * 86400 ))
count=0

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

[[ -d "$INFO_DIR" ]] || { log "INFO: No trash info dir found, nothing to do."; exit 0; }

for info_file in "$INFO_DIR"/*.trashinfo; do
    # If glob matched nothing, the literal string is returned, skip it
    [[ -f "$info_file" ]] || continue

    # Extract DeletionDate (spec says use first occurrence)
    deletion_date=$(grep -m1 '^DeletionDate=' "$info_file" | cut -d= -f2- | tr -d '[:space:]')

    if [[ -z "$deletion_date" ]]; then
        log "WARN: No DeletionDate in $(basename "$info_file"), skipping."
        continue
    fi

    deletion_epoch=$(date -d "$deletion_date" +%s 2>/dev/null)

    if [[ -z "$deletion_epoch" ]]; then
        log "WARN: Could not parse date '$deletion_date' in $(basename "$info_file"), skipping."
        continue
    fi

    if (( deletion_epoch < cutoff )); then
        item_name=$(basename "$info_file" .trashinfo)
        target="$FILES_DIR/$item_name"

        # -e covers regular files/dirs; -L also catches broken symlinks
        if [[ -e "$target" || -L "$target" ]]; then
            rm -rf -- "$target"
        fi

        rm -f -- "$info_file"

        log "DELETED: $item_name (trashed on $deletion_date)"
        (( count++ ))
    fi
done

log "Done. Removed $count item(s) older than $MAX_DAYS days."
