#!/bin/sh
set -e

# Increase keyboard speed
defaults write -g InitialKeyRepeat -int 14
defaults write -g KeyRepeat -int 1
defaults write -g ApplePressAndHoldEnabled -bool no

# Finder
defaults write com.apple.finder AppleShowAllExtensions -boolean yes
defaults write com.apple.finder AppleShowAllFiles -boolean yes
defaults write com.apple.finder PathBarRootAtHome -bool yes
defaults write com.apple.finder _FXShowPosixPathInTitle -bool yes

# Dock
defaults write com.apple.dock orientation -string "left"
defaults write com.apple.dock autohide -boolean yes
defaults write com.apple.dock magnification -boolean yes
defaults write com.apple.dock largesize 65  # magnification factor

# Make dock appear faster
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.5
defaults write com.apple.dock expose-animation-duration -float 0.15

# Show battery percentage
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center

# Top left screen corner
defaults write com.apple.dock wvous-tl-corner -int 6
defaults write com.apple.dock wvous-tl-modifier -int 0

# Top right screen corner
defaults write com.apple.dock wvous-tr-corner -int 10
defaults write com.apple.dock wvous-tr-modifier -int 0

# Bottom left screen corner
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-bl-modifier -int 0

# Bottom left screen corner
defaults write com.apple.dock wvous-br-corner -int 4
defaults write com.apple.dock wvous-br-modifier -int 0

killall cfprefsd
killall Finder
killall Dock
killall SystemUIServer
