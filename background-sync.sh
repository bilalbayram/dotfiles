#!/bin/bash
#
# background-sync.sh - Declarative LaunchAgent management
# Dotfiles are the source of truth for declared LaunchAgents.
# Usage: make background
#        ./background-sync.sh --dry-run
#        ./background-sync.sh --wipe-unmanaged
#

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAUNCHAGENTS_SRC="$DOTFILES_DIR/launchagents"
LAUNCHAGENTS_DST="$HOME/Library/LaunchAgents"
DRY_RUN=0
WIPE_UNMANAGED=0

for arg in "$@"; do
    case "$arg" in
        --dry-run)
            DRY_RUN=1
            ;;
        --wipe-unmanaged)
            WIPE_UNMANAGED=1
            ;;
        *)
            echo "Unknown argument: $arg" >&2
            exit 2
            ;;
    esac
done

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[+]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
log_error() { echo -e "${RED}[-]${NC} $1"; }

run() {
    if [ "$DRY_RUN" -eq 1 ]; then
        printf '    would run:'
        printf ' %q' "$@"
        printf '\n'
    else
        "$@"
    fi
}

label_for() {
    /usr/libexec/PlistBuddy -c 'Print :Label' "$1" 2>/dev/null || basename "$1" .plist
}

unload_agent() {
    local plist="$1"
    local label
    label="$(label_for "$plist")"
    run launchctl bootout "gui/$(id -u)/$label" 2>/dev/null || true
}

mkdir -p "$LAUNCHAGENTS_DST"

if [ "$DRY_RUN" -eq 1 ]; then
    log_warn "Dry run only; no LaunchAgents will be changed"
fi

for plist in "$LAUNCHAGENTS_DST"/*.plist; do
    [ -e "$plist" ] || continue

    filename=$(basename "$plist")
    declared="$LAUNCHAGENTS_SRC/$filename"

    if [ -e "$declared" ]; then
        continue
    fi

    if [ -L "$plist" ]; then
        target=$(readlink "$plist")
        case "$target" in
            "$LAUNCHAGENTS_SRC"/*)
                log_warn "Removing stale managed agent: $filename"
                unload_agent "$plist"
                run rm -f "$plist"
                ;;
            *)
                log_info "Preserving unmanaged symlink: $filename"
                ;;
        esac
    elif [ "$WIPE_UNMANAGED" -eq 1 ]; then
        log_warn "Removing unmanaged agent: $filename"
        unload_agent "$plist"
        run rm -f "$plist"
    else
        log_info "Preserving unmanaged agent: $filename"
    fi
done

log_info "Syncing agents from dotfiles..."

plist_count=0
for plist in "$LAUNCHAGENTS_SRC"/*.plist; do
    [ -e "$plist" ] || continue
    
    filename=$(basename "$plist")
    label="$(label_for "$plist")"
    dest="$LAUNCHAGENTS_DST/$filename"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        unload_agent "$dest"
        run rm -f "$dest"
    fi

    run ln -s "$plist" "$dest"
    log_info "Linked: $filename"

    if [ "$DRY_RUN" -eq 1 ]; then
        log_info "Would load: $label"
    elif launchctl bootstrap "gui/$(id -u)" "$dest" 2>/dev/null; then
        log_info "Loaded: $label"
    else
        launchctl kickstart -k "gui/$(id -u)/$label" 2>/dev/null || true
    fi
    
    ((plist_count++))
done

if [ "$plist_count" -eq 0 ]; then
    if [ "$WIPE_UNMANAGED" -eq 1 ]; then
        log_warn "No .plist files in launchagents/ - unmanaged agents were removed"
    else
        log_warn "No .plist files in launchagents/ - nothing declared to sync"
    fi
else
    log_info "Synced $plist_count agent(s)"
fi

echo ""
log_info "Current ~/Library/LaunchAgents/:"
ls -la "$LAUNCHAGENTS_DST"/ 2>/dev/null || echo "  (empty)"

echo ""
log_info "Done. Use --wipe-unmanaged only after reviewing every existing agent."
