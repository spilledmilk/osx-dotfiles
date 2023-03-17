# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
# prompt spaceship
# source ~/.spaceshiprc.zsh

# Git Autocomplete
autoload -Uz compinit
compinit -u

# ZSH Syntax Highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# SLI command completion
# source ~/sli_zsh_completer.sh

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
alias auto='cd ~/dev/wl-farmers-toggle'
alias sdk='cd ~/dev/platform-sdk'

alias slidev='sli dev changelog'
alias sdklink='yarn link-package'
alias applink='yarn pkg:sdk:link'
alias app-unlink='yarn pkg:sdk:unlink'
alias sdk-unlink='yarn unlink "@sureapp/platform-sdk"'
alias yi='yarn install'

alias g='git'
alias pull='git fetch && git pull'
alias gr='git restore'
alias gs='git status'
alias gcb='git checkout -b'
alias gc='git checkout'
alias ga='git add'
alias gcm='git commit -m'
alias gpo='git push origin'
alias gmd='git merge develop'
alias develop='git checkout develop'
alias switch='git checkout @{-1}'
alias clone='git clone'

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

function push() {
  current_branch=$(git name-rev --name-only HEAD)
  if [[ "$current_branch" != "develop" ]]; then
    git push origin $current_branch
  fi
}

function cd() {
  builtin cd $1 && ls
}
autoload -Uz cd
