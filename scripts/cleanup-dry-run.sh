#!/usr/bin/env bash
set -u

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

run() {
    printf '\n==> %s\n' "$*"
    "$@"
}

run brew bundle check --file="$root/Brewfile" --verbose
run brew bundle cleanup --file="$root/Brewfile" --all
run brew autoremove --dry-run
run brew cleanup -n

if command -v pipx >/dev/null 2>&1; then
    run pipx list
fi

if command -v npm >/dev/null 2>&1; then
    run npm list -g --depth=0
fi

if command -v uv >/dev/null 2>&1; then
    run uv tool list
fi

if command -v cargo >/dev/null 2>&1; then
    run cargo install --list
fi
