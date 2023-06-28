echo -e "\033[1;34m\n==>\033[0m \033[1mTime for GitHub setup..."
echo -en "\033[1;32m?\033[0m "
read -p "Your name: " ghname
#read -p 'Name? ' ghname
echo -en "\033[1;32m?\033[0m "
read -p "Your GitHub account email: " ghemail
#read -p 'What is your Github email? ' ghemail

# Check if gitconfig file exists and is configured
# Configs
username="git config --global user.name \"${ghname}\""
email="git config --global user.email \"${ghemail}\""

if ! test $(ls ~ | grep "gitconfig"); then
  touch ~/.gitconfig
else
  # Check configuration is correct, otherwise add lines
  if ! test $(cat ~/.gitconfig | grep "${ghname}"); then
    echo $username >> ~/.gitconfig
  fi

  if ! test $(cat ~/.gitconfig | grep "${ghemail}"); then
    echo $username >> ~/.gitconfig
  fi
fi

# Generate a new key
echo -e "\033[1m\nWhen prompted to enter a file to save the key, simply press ENTER."
echo -e "\033[1mWhen prompted for a password, type a secure password."
echo -e "\033[1mCreating new SSH key using email..."
ssh-keygen -t ed25519 -C "${ghemail}"

# Add SSH key to the ssh-agent
echo -e "\033[1;34m\n==>\033[0m \033[1mStarting ssh-agent in background..."
eval "$(ssh-agent -s)"

# Check if config file exists
# If config file exists, output content
# Otherwise, create file and add necessary provided content
if test $(ls ~/.ssh | grep "config"); then
  echo $(cat ~/.ssh/config)
else
  # Create a config file
  touch ~/.ssh/config
  # Add necessary content
  echo "Host *" >> ~/.ssh/config
  echo "  AddKeysToAgent yes" >> ~/.ssh/config
  echo "  UseKeychain yes" >> ~/.ssh/config
  echo "  IdentityFile ~/.ssh/id_ed25519" >> ~/.ssh/config
fi

# Add SSH private key to ssh-agent and store passphrase in keychain
echo -e "\033[1;34m\n==>\033[0m \033[1mAdding private key to ssh-agent and storing passphrase in keychain..."
ssh-add -apple-use-keychain ~/.ssh/id_ed25519

# Add SSH key to Github account
# Authenticate to Github CLI
echo -e "\033[1;34m\n==>\033[0m \033[1mAuthenticate to GitHub CLI..."
gh auth refresh -h github.com -s admin:public_key
gh auth login

# Title for key
echo -e "\033[1;34m\n==>\033[0m \033[1mFinishing up GitHub setup..."
echo -en "\033[1;32m?\033[0m "
read -p "What do you want to title your key in Github? (For example, \"Sure laptop\": " ghtitle

# Add SSH key to github account
gh ssh-key add ~/.ssh/id_ed25519.pub -t "${ghtitle}"
