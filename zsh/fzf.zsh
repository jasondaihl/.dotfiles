[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# npm script runner
nr-fzf() {
  local script
  script=$(jq -r '.scripts | keys[]' package.json 2>/dev/null | fzf)
  [[ -n "$script" ]] && npm run "$script"
}