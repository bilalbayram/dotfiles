#!/usr/bin/env bash
set -e

# ----------------------------------------
# GENERAL TEXT / INPUT
# ----------------------------------------

# Disable all smart typography features system-wide
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# ----------------------------------------
# TRACKPAD — Three Finger Drag
# ----------------------------------------

# Enable three-finger drag
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad Dragging -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging -bool true

# ----------------------------------------
# FINDER 
# ----------------------------------------

# Always show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show full POSIX path in title bar
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Default Finder view = List
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable warning when changing file extensions
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Prevent .DS_Store creation on network drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# ----------------------------------------
# SPACES / MISSION CONTROL
# ----------------------------------------

# Shared Spaces across displays (NOT separate)
defaults write com.apple.spaces spans-displays -bool false

# ----------------------------------------
# HOT CORNERS
# ----------------------------------------

# Top-left corner → Lock Screen
defaults write com.apple.dock wvous-tl-corner -int 13
defaults write com.apple.dock wvous-tl-modifier -int 0

# ----------------------------------------
# SCREENSHOTS
# ----------------------------------------

# Create screenshot directory
mkdir -p "$HOME/Desktop/Screenshots"

# Save screenshots to Desktop/Screenshots
defaults write com.apple.screencapture location -string "$HOME/Desktop/Screenshots"

# ----------------------------------------
# SAFARI — Developer Features
# ----------------------------------------

# Enable Develop menu (ignore errors if Safari prefs are locked)
defaults write com.apple.Safari IncludeDevelopMenu -bool true || true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true || true
defaults write com.apple.Safari WebKitPreferences.developerExtrasEnabled -bool true || true

# ----------------------------------------
# SECURITY / PRIVACY
# ----------------------------------------

# Require password immediately after sleep or screen saver
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Looser Gatekeeper (allow apps from anywhere; ignore failure on newer macOS)
sudo spctl --master-disable || true

# ----------------------------------------
# APPLY CHANGES
# ----------------------------------------

killall Finder > /dev/null 2>&1 || true
killall Dock > /dev/null 2>&1 || true
killall SystemUIServer > /dev/null 2>&1 || true
killall Safari > /dev/null 2>&1 || true

echo "macOS defaults applied."
