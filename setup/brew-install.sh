source './utils.sh'

brew_install() {
  # Check if Homebrew is installed
  if ! test $(which brew); then
    echo -e "\033[1;34m\n==>\033[0m \033[1mInstalling Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi

  # Confirm Homebrew works
  echo -e "\033[1;34m\n==>\033[0m \033[1mGetting brew ready..."
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/${USER}/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"  

  if assert_cmd_exists "brew"; then
    # Complete brew setup, including installing packages
    # Update to ensure latest
    echo -e "\033[1;34m\n==>\033[0m \033[1mUpdating Homebrew to latest..."
    brew update

    # Upgrade any installed formulae
    echo -e "\033[1;34m\n==>\033[0m \033[1mUpdating any installed formulae..."
    brew upgrade

    # Install packages
    echo -e "\033[1;34m\n==>\033[0m \033[1mInstalling packages from txt file..."
    xargs brew install < ./brew-pkgs.txt

    # Check if config lines exist
    if grep -Fxq "source $(brew --prefix)/opt/spaceship/spaceship.zsh" ./.zshrc; then
      echo "Looks good!"
    else
      echo "source $(brew --prefix)/opt/spaceship/spaceship.zsh" >>! ~/.zshrc
    fi

  else
    echo -e "\033[1;34m\n==>\033[0m \033[1mBrew error. Command not found."
  fi
}

# Execute
brew_install
