#==[Bash Completion]===============================================
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
#==================================================================

#==[Bashrc]========================================================
# Bash completion has to be initialised first otherwise fzf does
# not work.
# https://github.com/junegunn/fzf/issues/716#issuecomment-587164331
[ -r ~/.bashrc ] && . ~/.bashrc
#==================================================================

#==[SDKMan]========================================================
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/dawidkoprowski/.sdkman"
[[ -s "/Users/dawidkoprowski/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/dawidkoprowski/.sdkman/bin/sdkman-init.sh"
#==================================================================

#==[Rust/cargo]====================================================
source "$HOME/.cargo/env"
#==================================================================

#==[pyenv]=========================================================
# https://github.com/pyenv/pyenv#installation
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
#==================================================================
