autoload -U promptinit; promptinit

# Autocomplete
# Git 
autoload -Uz compinit
compinit -u
# fx
source <(fx --comp zsh)

# ZSH Syntax Highlighting
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source "/opt/homebrew/opt/zsh-git-prompt/zshrc.sh"

# zplug
source ~/.zplug/init.zsh
zplug "mafredri/zsh-async", from:github
#zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
zplug "zdharma/fast-syntax-highlighting", as:plugin, defer:2
zplug load
# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# SLI command completion
source ~/My\ Drive/Backup/sli_zsh_completer.sh

# Deno
export DENO_INSTALL="/Users/jane/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

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
alias preme='cd ~/dev/surepreme'
alias de='cd ~/dev/document-engineer'
alias ee='cd ~/dev/email-engineer'
alias bloc='cd ~/dev/berry-local-dev'
alias tdl='cd ~/dev/toggle-fe'

alias slip='sli dev changelog -p'
alias sdklink='yarn link-package'
alias applink='yarn pkg:sdk:link'
alias app-unlink='yarn pkg:sdk:unlink'
alias sdk-unlink='yarn unlink-package'
alias yi='yarn install'
alias npmlogin='npm login --registry=https://npm.pkg.github.com --scope=@sureapp'

alias run="jq '.scripts | keys[]' package.json | fzf | xargs yarn"
alias rund="jq '.tasks | keys[]' deno.json | fzf | xargs deno task"

alias ci="circleci"

alias g='git'
alias pull='git fetch && git pull'
alias gr='git restore'
alias gs='git status'
alias gbd='git branch -D'
alias gch='git checkout'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'
alias gpo='git push origin'
alias gmd='git merge develop'
alias develop='git checkout develop'
alias g-='git checkout @{-1}'
alias gcl='git clone'
alias gst='git stash'

alias v='vim'
alias vz='vim ~/.zshrc'
alias vv='vim ~/.vimrc'

alias run="jq '.scripts | keys[]' package.json | fzf | xargs yarn"
alias rund="jq '.tasks | keys[]' deno.json | fzf | xargs deno task"

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
export PATH="/opt/homebrew/bin/python3:$PATH"
export PATH="/opt/homebrew/opt/node@18/bin:$PATH"

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

function gcb() {
	git fetch origin && git checkout -b $1 origin/develop && git branch --unset-upstream
}

function gmD() {
	git checkout develop && pull && g- && gmd
}

function ys () {
  partner=$1
  auto='wl-toggle-auto'
  postmark='postmark-emails'
  platformapp='platform-app'
  if [[ $(pwd) == *"$auto"* && $# == 1 ]]; then
	  yarn start:$partner
  elif [[ $(pwd) == *"$auto"* ]]; then
	  yarn start:toggle
  elif [[ $(pwd) == *"$postmark"* || $(pwd) == *"$platformapp"* ]]; then
    yarn start
  fi
}

function cy () {
  partner=$1
  yarn cy:open:$partner
}

function scaffold() {
  product=$1
  states=$@
  if [[ $product == "auto" ]]; then
    for arg in $states; do
      touch src/auto/constants/region/toggle/${arg}.tsx
    done
  elif [[ $product == "tai" ]]; then
    for arg in $states; do
      touch src/auto/constants/region/toyota/${arg}.tsx
    done
  elif [[ $product == "all" ]]; then
    for arg in $states; do
      touch src/auto/constants/region/toggle/${arg}.tsx
      touch src/auto/constants/region/toyota/${arg}.tsx
    done
  fi
}

cleanup_branches() {
  git remote prune origin && git branch -vv | grep ': gone' | grep -v '\*' | awk '{ print $1; }' | xargs -r -n1 git branch -D;
}

function dockerBuildSurepreme() {
        export PRIVATE_REPO_TOKEN="$(
        aws codeartifact get-authorization-token \
                --profile registries-read \
                --domain sure \
                --query authorizationToken \
                --duration-seconds 1200 \
                --output text
        )";
        export DOCKER_BUILDKIT=1;
        docker build --tag surepreme:latest --secret id=PRIVATE_REPO_TOKEN .;
}

function dockerNuke() {
    # docker container stop $(docker ps -qa)
    # docker system prune --all
    docker kill $(docker ps -q)
    docker rm $(docker ps -a -q)
    docker rmi $(docker images -q)
    docker stop "$(docker ps -a -q)"
    docker rmi -f $(docker images -aq)
    docker volume rm -f $(docker volume ls -q)
    docker system prune --all
}

function farmers-qa() {
		# This function
    # 1. Logs into a profile defined in ~/.aws/config (default is `np-farmers`)
    #    A profile can be defined by specifying it as the first argument
    #    i.e. `farmers-qa sure`
    # 2. Defines the needed setting in the k8s config file ~/.kube/config
    # 3. Uses `sli k8s login` to load menu to select qa pod.
    local profile

    # Default profile in ~/.aws/config will be "np-farmers"
    [ -z "$1" ] && profile="np-farmers" || profile=$1

    aws-sso-login "$profile" &> /dev/null

    aws eks update-kubeconfig --name farmers-qa-k8s-use1 --profile "$profile" --alias farmers-qa-k8s-use1

    sli k8s login farmers-qa-k8s-use1

}

function jsondiff() {
  # Ensure two arguments are passed
  if [ $# -ne 2 ]; then
    echo "Usage: diff_json <json_file1> <json_file2>"
    return 1
  fi

  # Create temporary files
  temp1=$(mktemp)
  temp2=$(mktemp)

  # Sort the JSON files
  cat "$1" | jq --sort-keys . > "$temp1" && mv "$temp1" "$1"
  cat "$2" | jq --sort-keys . > "$temp2" && mv "$temp2" "$2"

  # Diff the sorted JSON files
  jd -color "$1" "$2"

  # Clean up temporary files
  rm -f "$temp1"
  rm -f "$temp2"
}

function cd() {
  builtin cd $1 && ls
}
autoload -Uz cd

# Starship
export STARSHIP_CONFIG=~/osx-dotfiles/terminal/starship.toml
eval "$(starship init zsh)"


PATH=~/.console-ninja/.bin:$PATH

# Added by Windsurf
export PATH="/Users/jane/.codeium/windsurf/bin:$PATH"
