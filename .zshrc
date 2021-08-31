
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/dawidkoprowski/.sdkman"
[[ -s "/Users/dawidkoprowski/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/dawidkoprowski/.sdkman/bin/sdkman-init.sh"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
