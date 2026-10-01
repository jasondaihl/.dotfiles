#!/usr/bin/env zsh

# Node / JS config
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
eval "$(fnm env --use-on-cd --shell zsh)"

# NODE_ENV is intentionally not set globally — set it per-project via direnv (.envrc).
export NODE_OPTIONS="--max-old-space-size=4096"

alias ni="npm install"
alias nr="npm run"
alias ns="npm start"
alias nt="npm test"

alias pi="pnpm install"
alias pr="pnpm run"
alias px="pnpm dlx"

alias node-debug="node --inspect-brk"
