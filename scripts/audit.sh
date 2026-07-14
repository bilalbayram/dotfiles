#!/usr/bin/env bash
set -u

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
stamp="$(date +%Y-%m-%d-%H%M%S)"
out="$root/.cleanup/audit-$stamp.md"

mkdir -p "$root/.cleanup"

section() {
    printf '\n## %s\n\n' "$1" >> "$out"
}

capture() {
    local title="$1"
    shift

    section "$title"
    printf '```text\n' >> "$out"
    "$@" >> "$out" 2>&1
    printf '```\n' >> "$out"
}

printf '# Mac Cleanup Audit\n\nGenerated: %s\n' "$(date)" > "$out"

capture "Git Status" git -C "$root" status --short --branch
capture "Managed Dotfile Status" bash "$root/scripts/dotfiles-status.sh"
capture "Brew Bundle Check" brew bundle check --file="$root/Brewfile" --verbose
capture "Brew Cleanup Preview" brew bundle cleanup --file="$root/Brewfile" --all
capture "Brew Autoremove Preview" brew autoremove --dry-run
capture "Brew Cache Cleanup Preview" brew cleanup -n
capture "Brew Taps" brew tap
capture "Brew Leaves" brew leaves
capture "Brew Casks" brew list --cask -1
capture "Brew Services" brew services list
capture "Mac App Store Apps" mas list

if command -v npm >/dev/null 2>&1; then
    capture "Global npm Packages" npm list -g --depth=0
fi

if command -v pipx >/dev/null 2>&1; then
    capture "pipx Packages" pipx list
fi

if command -v uv >/dev/null 2>&1; then
    capture "uv Tools" uv tool list
fi

if command -v cargo >/dev/null 2>&1; then
    capture "Cargo Installs" cargo install --list
fi

if command -v go >/dev/null 2>&1; then
    capture "Go Binaries" find "$(go env GOPATH)/bin" -maxdepth 1 -type f -print
fi

capture "User LaunchAgents" find "$HOME/Library/LaunchAgents" -maxdepth 1 -name '*.plist' -print
capture "System LaunchAgents and Daemons" find /Library/LaunchAgents /Library/LaunchDaemons -maxdepth 1 -name '*.plist' -print
capture "Applications" find /Applications "$HOME/Applications" -maxdepth 1 -name '*.app' -print
capture "Large Home Development Directories" du -hd1 "$HOME/Developer"
capture "Large Developer Caches" du -hd1 "$HOME/Library/Developer"
capture "Large Application Support Directories" du -hd1 "$HOME/Library/Application Support"
capture "Large Dot Directories" du -sh "$HOME/.cache" "$HOME/.local" "$HOME/.codex" "$HOME/.bun" "$HOME/.cargo" "$HOME/.rustup" "$HOME/.npm"

printf 'Wrote %s\n' "$out"
