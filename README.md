# dotfiles

Personal macOS configuration.

## Usage

```bash
make          # sync configs (fish, cursor, hushlogin)
make brew     # install apps from Brewfile
make tr-keyboard  # Turkish keyboard remapping (Karabiner)
make clean    # remove all symlinks
```

## What gets synced

| Source | Target |
|--------|--------|
| `config.fish` | `~/.config/fish/config.fish` |
| `fish/functions/` | `~/.config/fish/functions/` |
| `cursor-settings.json` | `~/Library/Application Support/Cursor/User/settings.json` |
| `cursor-keybindings.json` | `~/Library/Application Support/Cursor/User/keybindings.json` |
| `karabiner.json` | `~/.config/karabiner/karabiner.json` (tr-keyboard only) |

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
