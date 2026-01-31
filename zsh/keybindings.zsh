#!/usr/bin/env zsh

# Better history search
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Word jumps
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
