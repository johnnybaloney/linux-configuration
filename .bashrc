#==[Terminal Colours]==============================================

export CLICOLOR=1
# debian colour scheme
export LSCOLORS=ExGxFxdxCxDxDxxbaDecac

#==================================================================

#==[kubectl Aliases]===============================================

alias k8='kubectl'
alias k8-v3-dawid0003='kubectl --kubeconfig ~/.kube/v3-dawid0003.conf'
alias k8-dawid-irsa-test='kubectl --kubeconfig ~/.kube/dawid-irsa-test.conf'

alias kubectl-get-events='kubectl get events --sort-by=.metadata.creationTimestamp'

#==================================================================

#==[Aliases]=======================================================

alias ll='ls -la'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."
alias back='cd $OLDPWD'
alias dir="tree -d"
alias grep="grep -i --color"
alias safedate='date +%Y-%m-%d-%H-%M-%S'
alias less='less -N'
alias terraform='terraform -no-color'

#--[git]-----------------------------------------------------------

alias git-dir-diff="git difftool --dir-diff"
alias gitinfo="git remote show origin"
# graphs
# colors and formatting info: https://mirrors.edge.kernel.org/pub/software/scm/git/docs/git-config.html
# simple graph one-liner: 
#   git log --graph --oneline --all
alias git-graph-name-date='git log --graph --full-history --all --color --date=iso8601 --pretty="%x09 %Cblue%ad %C(cyan)%h%Creset%C(auto)%d %Creset%s%Creset %C(yellow)(%an)"'
alias git-graph='git log --graph --full-history --all --color --pretty="%x09 %C(cyan)%h%Creset%C(auto)%d %Creset%s"'
# Shows repo name, current branch and tag, and current revision
alias git-where-am-i='basename $(git remote get-url origin) .git && currentbranch=$(git branch --show-current); currenttag=$(git describe --tags); if [ -z $currentbranch ]; then currentbranch="<detached>"; fi; echo -e "$currentbranch ($currenttag)" && git rev-parse --short HEAD'
gitAheadBehind() {
  echo "Compared to {$1}, {$2} is ahead/behind:"
  git rev-list --left-right --count $2...$1
}
# Takes two branch names as arguments (e.g. develop master) and determines 
# where they are with respect to each other. The branch has to available
# (checked out) locally.
alias git-ahead-behind=gitAheadBehind
alias git-tags-with-dates='git log --tags --simplify-by-decoration --pretty="format:%ai %d"'

#------------------------------------------------------------------

alias aws-cloudformation-describe-stacks-names='aws cloudformation describe-stacks | jq '"'"'.Stacks[] | {name: .StackName, desc: .Description}'"'"''

#==================================================================

#==[Aliased functions]=============================================

# convert string to lowercase and dashes
#
# $ echo $(safename 'aA&*foo bar 123')
# aafoo-bar-123
_safename() {
  echo "$@" | tr '\n' ' ' | sed -E 's/[^[:alnum:] -]+//g' | tr '[:upper:]' '[:lower:]' | sed -E 's/[[:space:]]+/-/g' | sed -E 's/[-]+/-/g' | sed -E 's/-$//'
}
alias safename='_safename'

_listContainerImagesByPod() {
  kubectl get pods -o=jsonpath='{range .items[*]}{"\n"}{.metadata.name}{": "}{range .spec.containers[*]}{.image}{", "}{end}{end}' | sort
}
alias kubectl-list-container-images-by-pod='_listContainerImagesByPod'

_exportArtifactoryUserAndPassword() {
  local apikey=$(cat /Users/dawidkoprowski/.jfrog/jfrog-cli.conf | jq -r ".artifactory[0].password")
  local user=$(cat /Users/dawidkoprowski/.jfrog/jfrog-cli.conf | jq -r ".artifactory[0].user")

  export ARTIFACTORY_USERNAME=$user
  export ARTIFACTORY_APIKEY=$apikey
}
alias export-artifactory-creds='_exportArtifactoryUserAndPassword'

_mkdirAndChange() {
  local dir=$1
  [ ! -z $dir ] && mkdir $dir && cd $_
}
alias mkcd='_mkdirAndChange'

_randomString() {
  local numberOfCharacters=$1
  head /dev/urandom | LC_ALL=C tr -dc A-Za-z0-9 | head -c$numberOfCharacters
}
alias random-string='_randomString'

_millisToFormatted() {
  local millis=$1
  python -c "from datetime import datetime;print(datetime.fromtimestamp($millis/1000).strftime('%Y-%m-%d %H:%M:%S.%f')[:-3])"
}
alias millis-to-formatted='_millisToFormatted'

#==================================================================

#==[PS1]===========================================================

COLOUR_RED="\[\033[0;31m\]"
COLOUR_YELLOW="\[\033[0;33m\]"
COLOUR_GREEN="\[\033[0;32m\]"
COLOUR_OCHRE="\[\033[38;5;95m\]"
COLOUR_BLUE="\[\033[0;34m\]"
COLOUR_WHITE="\[\033[0;37m\]"
COLOUR_RESET="\[\033[0m\]"
COLOUR_BOLD_BLUE="\[\033[1;34m\]"
COLOUR_BOLD_GREEN="\[\033[1;32m\]"
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(git::\1)/'
}
PS1="\n"
PS1+="[\t \w] "
PS1+="$COLOUR_YELLOW\$(parse_git_branch)$COLOUR_RESET"
PS1+="\n"
PS1+="$COLOUR_BOLD_BLUE\u$COLOUR_RESET"
PS1+="@"
PS1+="$COLOUR_BOLD_BLUE\h$COLOUR_RESET "
PS1+="$COLOUR_BOLD_GREEN\$$COLOUR_RESET "
export PS1

#==================================================================

#==[Bash History in Multiple Terminal Windows]=====================

HISTSIZE=999999                   # big big history
HISTFILESIZE=999999               # big big history

# Avoid duplicates
HISTCONTROL=ignoredups:erasedups
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# After each command, append to the history file and reread it
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

#==================================================================

#==[HSTR]==========================================================

# HSTR configuration - add this to ~/.bashrc
alias hh=hstr                    # hh to be alias for hstr
export HSTR_CONFIG=hicolor       # get more colors
shopt -s histappend              # append new history items to .bash_history
export HISTCONTROL=ignorespace   # leading space hides commands from history
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
# ensure synchronization between bash memory and history file
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
# if this is interactive shell, then bind hstr to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi
# if this is interactive shell, then bind 'kill last command' to Ctrl-x k
if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a hstr -k \C-j"'; fi

#==================================================================

#==[Bash Completion]===============================================
# Prerequisite: $ brew install bash-completion
source /usr/local/etc/profile.d/bash_completion.sh

# kubectl
source <(kubectl completion bash)

# terraform
complete -C /usr/local/bin/terraform terraform
#==================================================================

#==[direnv]========================================================
eval "$(direnv hook bash)"
EDITOR=/usr/bin/vim
#==================================================================

#==[Rust/cargo]====================================================
source "$HOME/.cargo/env"
#==================================================================

#==[Enhanced cd/bd]================================================
# Uses a stack of visited directories to make it easier to go back.
# https://mhoffman.github.io/2015/05/21/how-to-navigate-directories-with-the-shell.html
function cd() {
  if [ "$#" = "0" ]
  then
  pushd ${HOME} > /dev/null
  elif [ -f "${1}" ]
  then
    ${EDITOR} ${1}
  else
  pushd "$1" > /dev/null
  fi
}

function bd(){
  if [ "$#" = "0" ]
  then
    popd > /dev/null
  else
    for i in $(seq ${1})
    do
      popd > /dev/null
    done
  fi
}
#==================================================================

#==[fzf - command-line fuzzy finder]===============================
# https://github.com/junegunn/fzf
# https://github.com/junegunn/fzf#fuzzy-completion-for-bash-and-zsh

# To install useful key bindings and fuzzy completion:
# $(brew --prefix)/opt/fzf/install

# CTRL-T - Paste the selected files and directories onto the command-line
#   Set FZF_CTRL_T_COMMAND to override the default command
#   Set FZF_CTRL_T_OPTS to pass additional options
# CTRL-R - Paste the selected command from history onto the command-line
#   If you want to see the commands in chronological order, press CTRL-R 
#   again which toggles sorting by relevance
#   Set FZF_CTRL_R_OPTS to pass additional options
# ALT-C - cd into the selected directory
#   Set FZF_ALT_C_COMMAND to override the default command
#   Set FZF_ALT_C_OPTS to pass additional options

# If you're on a tmux session, you can start fzf in a tmux split-pane or 
# in a tmux popup window by setting FZF_TMUX_OPTS (e.g. -d 40%). 
# See fzf-tmux --help for available options.

# Restrict the search to the current directory.
export FZF_DEFAULT_COMMAND="find . -maxdepth 1"
# Instead of cd **[TAB] use cd [ctrl+t] to get results only from current directory.
#export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Disable uzing fzf for command history. Overrides the fzf override.
# hstr (for emacs (default), check which keymap with 'set -o'):
# http://dvorka.github.io/hstr/CONFIGURATION.html
bind '"\C-r": "\C-a hstr -- \C-j"'
# bash built-in:
#bind '"\C-r": reverse-search-history'
#==================================================================
