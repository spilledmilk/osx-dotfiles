# MacOS
echo -e "\033[1;34m\n==>\033[0m \033[1mUpdating OSX..."
echo -e "\033[1;34m==>\033[0m \033[1mIf restart required, re-run script"

# Install available updates
sudo softwareupdate -ia --verbose

echo -e "\033[1;33m\n*------------------------------*\033[0m"

# Check if xcode command line tools is installed
if ! test $(which xcode-select); then
  echo -e "\033[1;34m\n==>\033[0m \033[1mInstalling Xcode command line tools..."
  xcode-select --install
else
  echo -e "\033[1;32m\nXcode command line tools already installed.\033[0m"
fi

# Set OSX preferences
echo -e "\033[1;34m\n==>\033[0m \033[1mSetting up OSX preferences..."
# Show the ~/Library folder
	chflags nohidden ~/Library
	echo "Library shown."

# Display full path in Finder title window
	defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
	echo "Finder shows full path in title."

# Save screenshots in ~/Pictures/Screenshots folder
	mkdir $HOME/Pictures/Screenshots
	defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
	echo "Screenshot now will appear @ $HOME/Pictures/Screenshots"

# Finder: show all filename extensions
	defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  echo "Finder showing filename extensions"

# Automatically quit printer app once the print jobs complete
	defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
	echo "Printer app quit once the prints complete."

# Hide all Desktop items
  defaults write com.apple.finder CreateDesktop -bool false
  killall Finder
  echo "Desktop does not show icons"
