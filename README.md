# dotfiles

Personal macOS configuration.

## Usage

```bash
make          # sync configs (fish, vscodium, zed, hushlogin)
make status   # show linked, missing, and drifted live configs
make audit    # write a non-destructive inventory to .cleanup/
make cleanup-dry-run  # preview package/cache cleanup candidates
make brew     # install apps from Brewfile
make tr-keyboard  # Turkish keyboard remapping (Karabiner)
make clean    # remove repo-managed symlinks, preserving unmanaged files
```

## What gets synced

| Source | Target |
|--------|--------|
| `config.fish` | `~/.config/fish/config.fish` |
| `fish/functions/` | `~/.config/fish/functions/` |
| `vscodium-settings.json` | `~/Library/Application Support/VSCodium/User/settings.json` |
| `vscodium-keybindings.json` | `~/Library/Application Support/VSCodium/User/keybindings.json` |
| `zed-settings.json` | `~/.config/zed/settings.json` |
| `zed-keymap.json` | `~/.config/zed/keymap.json` |
| `karabiner.json` | `~/.config/karabiner/karabiner.json` (tr-keyboard only) |

## Cleanup workflow

```bash
make status
make cleanup-dry-run
make audit
```

Review `CLEANUP.md` before running destructive cleanup commands. `make
background` only reconciles declared LaunchAgents by default; use
`./background-sync.sh --dry-run` to preview changes and
`./background-sync.sh --wipe-unmanaged` only after reviewing every existing
agent.

## New machine setup

```bash
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Clone dotfiles
git clone https://github.com/yourusername/dotfiles ~/Developer/dotfiles
cd ~/Developer/dotfiles

# 3. Install everything
make brew
make
make tr-keyboard  # if using Turkish keyboard
```
