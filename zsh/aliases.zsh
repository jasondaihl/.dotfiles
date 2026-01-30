alias ls="eza --icons"
alias ll="eza -l --icons"
alias cat="bat"
alias reload="source ~/.zshrc"

# Git
alias gs="git status"
alias gd="git diff"
alias gl="git log --oneline --graph --decorate"

# Profile switching
alias personal="git config --global include.path ~/.dotfiles/git/gitconfig_personal && echo 'Switched to personal profile' && git config user.email"
alias work="git config --global include.path ~/.dotfiles/git/gitconfig_work && echo 'Switched to work profile' && git config user.email"