# nvm
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# fnm
eval "$(fnm env --use-on-cd --shell zsh)"

# Default node env
export NODE_ENV=development

# More memory for builds
export NODE_OPTIONS="--max-old-space-size=4096"