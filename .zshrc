autoload -U promptinit; promptinit

# Git Autocomplete
autoload -Uz compinit
compinit -u

# ZSH Syntax Highlighting
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source "/opt/homebrew/opt/zsh-git-prompt/zshrc.sh"

# SLI command completion
source ~/My\ Drive/Backup/sli_zsh_completer.sh

# Aliases
alias ls='ls -la'
alias c='clear'
alias u='cd ..'
alias u2='cd ../..'
alias sz='source ~/.zshrc'

alias ~='cd ~'
alias dev='cd ~/dev'
alias work='cd ~/workspace'
alias qa='cd ~/dev/qa-automation'
alias auto='cd ~/dev/wl-toggle-auto'
alias sdk='cd ~/dev/platform-sdk'
alias pmail='cd ~/dev/postmark-emails'
alias ho='cd ~/dev/wl-toggle-homeowners'
alias pa='cd ~/dev/platform-app'

alias slip='sli dev changelog -p'
alias sdklink='yarn link-package'
alias applink='yarn pkg:sdk:link'
alias app-unlink='yarn pkg:sdk:unlink'
alias sdk-unlink='yarn unlink-package'
alias yi='yarn install'
alias npmlogin='npm login --registry=https://npm.pkg.github.com --scope=@sureapp'

alias g='git'
alias pull='git fetch && git pull'
alias gr='git restore'
alias gs='git status'
alias gcb='git checkout -b'
alias gbd='git branch -D'
alias gc='git checkout'
alias ga='git add'
alias gcm='git commit -m'
alias gpo='git push origin'
alias gmd='git merge develop'
alias develop='git checkout develop'
alias g-='git checkout @{-1}'
alias gcl='git clone'

alias v='vim'
alias vz='vim ~/.zshrc'
alias vv='vim ~/.vimrc'

# Functions
function convertToGif() {
  input=$1
  filename="${input%.*}"
  ffmpeg -i $1 -vf fps=5,scale=1200:-1,smartblur=ls=-0.5,crop=iw:ih-2:0:0 $filename.gif
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="/Users/jane/.local/bin:$PATH" # Poetry
export PATH="/usr/local/sbin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

function gbs() {
  search_branch=$1
  git branch --list "*${search_branch}*"
}

function gcs() {
  search_branch=$1
  branch_options=()
  for branch in $(gbs "$search_branch"); do
    branch_options+=("$branch")
  done
  select branch in "${branch_options[@]}"; do
    git checkout "$branch"
    break
done
}

function push() {
  current_branch=$(git name-rev --name-only HEAD)
  if [[ "$current_branch" != "develop" ]]; then
    git push origin $current_branch
  fi
}

function yart() {
  arg=$1
  auto='wl-toggle-auto'
  postmark='postmark-emails'
  platformapp='platform-app'
  if [[ $(pwd) == *"$auto"* ]]; then
    yarn start:standalone:toggle
  elif [[ $(pwd) == *"$auto"* && $arg == "toyota" ]]; then
    yarn start:standalone:toyota
  elif [[ $(pwd) == *"$postmark"* || $(pwd) == *"$platformapp"* ]]; then
    yarn start
  fi
}

function scaffold() {
  product=$1
  states=$@
  if [[ $input == "auto" ]]; then
    for arg in $states; do
      touch src/auto/constants/region/toggle/${arg}.tsx
    done
  elif [[ $input == "tai" ]]; then
    for arg in $states; do
      touch src/auto/constants/region/toyota/${arg}.tsx
    done
  elif [[ $input == "all" ]]; then
    for arg in $states; do
      touch src/auto/constants/region/toggle/${arg}.tsx
      touch src/auto/constants/region/toyota/${arg}.tsx
    done
  fi
}

function cd() {
  builtin cd $1 && ls
}
autoload -Uz cd

# Starship
eval "$(starship init zsh)"
export PATH="/opt/homebrew/opt/node@18/bin:$PATH"
