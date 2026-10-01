#!/usr/bin/env bash
# Opinionated macOS system preferences for development.
# Idempotent and safe to re-run. Some changes require a logout/restart.
set -euo pipefail

echo "⚙️  Applying macOS defaults"

# Close System Settings so it doesn't overwrite changes we make below.
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

# ---------------------------------------------------------------------------
# Keyboard
# ---------------------------------------------------------------------------
# Fast key repeat (great for editing); disable press-and-hold accent popover
# so holding a key repeats instead.
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Disable automatic text "corrections" that fight code/markdown.
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# ---------------------------------------------------------------------------
# Finder
# ---------------------------------------------------------------------------
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
# Default to list view ("Nlsv").
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# Search the current folder by default.
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Don't write .DS_Store on network / USB volumes.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# ---------------------------------------------------------------------------
# Dock
# ---------------------------------------------------------------------------
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock tilesize -int 42
defaults write com.apple.dock show-recents -bool false

# ---------------------------------------------------------------------------
# Screenshots -> ~/Screenshots, PNG, no window shadow
# ---------------------------------------------------------------------------
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# ---------------------------------------------------------------------------
# Misc developer conveniences
# ---------------------------------------------------------------------------
# Expand save and print panels by default.
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
# Don't nag when opening apps downloaded from the internet.
defaults write com.apple.LaunchServices LSQuarantine -bool false
# Tap to click on the trackpad.
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# ---------------------------------------------------------------------------
# Apply
# ---------------------------------------------------------------------------
for app in Finder Dock SystemUIServer; do
  killall "$app" >/dev/null 2>&1 || true
done

echo "✅ macOS defaults applied. Some settings need a logout/restart to take effect."
