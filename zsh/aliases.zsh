#!/usr/bin/env zsh

alias ls="eza --icons"
alias ll="eza -l --icons"
alias cat="bat"
alias reload="source ~/.zshrc"

# Git
alias gs="git status"
alias gd="git diff"
alias gl="git log --oneline --graph --decorate"

# Profile switching (switch_profile is defined in zshrc)
alias personal="switch_profile personal"
alias work="switch_profile work"
