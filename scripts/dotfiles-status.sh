#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

check_path() {
    local kind="$1"
    local source="$2"
    local target="$3"

    printf '%s\n' "$target"

    if [ ! -e "$source" ]; then
        printf '  source missing: %s\n' "$source"
        return
    fi

    if [ -L "$target" ]; then
        local current
        current="$(readlink "$target")"
        if [ "$current" = "$source" ]; then
            printf '  linked\n'
        else
            printf '  linked elsewhere: %s\n' "$current"
        fi
        return
    fi

    if [ ! -e "$target" ]; then
        printf '  missing\n'
        return
    fi

    if [ "$kind" = "file" ] && cmp -s "$source" "$target"; then
        printf '  regular file, same contents\n'
    else
        printf '  unmanaged local %s\n' "$kind"
    fi
}

check_path file "$root/config.fish" "$HOME/.config/fish/config.fish"
check_path dir "$root/fish/functions" "$HOME/.config/fish/functions"
check_path file "$root/vscodium-settings.json" "$HOME/Library/Application Support/VSCodium/User/settings.json"
check_path file "$root/vscodium-keybindings.json" "$HOME/Library/Application Support/VSCodium/User/keybindings.json"
check_path file "$root/zed-settings.json" "$HOME/.config/zed/settings.json"
check_path file "$root/zed-keymap.json" "$HOME/.config/zed/keymap.json"
check_path file "$root/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
