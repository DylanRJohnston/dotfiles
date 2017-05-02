#!/bin/sh

# Credit where credit is due: https://github.com/robb/.dotfiles

# Disable the new window animation - every new window grows
# from a small one to a big one over a few hundred millisecs
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# Expand save panel by default.
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Expand print panel by default.
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Set keyboard repeat rate to "damn fast".
defaults write NSGlobalDomain KeyRepeat -int 2

# Set a shorter delay until key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable sound effects when changing volume
defaults write NSGlobalDomain com.apple.sound.beep.feedback -integer 0

# Use a dark menu bar / dock
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Use plain text for new documents in TextEdit.app
defaults write com.apple.TextEdit RichText -bool false

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# New Finder windows points to home
defaults write com.apple.finder NewWindowTarget -string "PfHm"

# Allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Use current directory as default search scope in Finder
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Show the status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Show absolute path in Finder's title bar.
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Enable scroll gesture (with modifier) to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true

# Disable sounds effects for user interface changes
defaults write com.apple.systemsound com.apple.sound.uiaudio.enabled -int 0

# Use AirDrop over every network interface and on unsupported Macs.
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

# Don't create dreaded .DS_Store files.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Don't want Photos.app to open up as soon as you plug something in?
defaults write com.apple.ImageCapture disableHotPlug -bool YES

# Show the ~/Library folder
chflags nohidden ~/Library

# Disable Resume system-wide
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

# Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Stop iTunes from responding to the keyboard media keys
#launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Set mouse tracking speed to reasonably fast
defaults write NSGlobalDomain com.apple.mouse.scaling -float 2

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Hide all desktop icons
defaults write com.apple.finder CreateDesktop -bool false

# Set the icon size to 32 points
defaults write com.apple.dock tilesize -int 32

# Prevent the Dock from changing size
defaults write com.apple.dock size-immutable -bool YES

# Disable the indicator lights for currently running apps
defaults write com.apple.dock show-process-indicators -bool true

#Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Set edge-dragging delay to 0.7
defaults write com.apple.dock workspaces-edge-delay -float 1.0

#Set trackpad speed higher
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 1.5

# Set up Safari for development.
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
# Move screen shots to ~/Screen Shots
mkdir -p ~/Pictures/screenshots
defaults write com.apple.screencapture location ~/Pictures/screenshots

# Disable press and hold
defaults write -g ApplePressAndHoldEnabled -bool false

open -a "Google Chrome" --args --make-default-browser
