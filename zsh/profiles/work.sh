# Git config
git config --global include.path "$DOTFILES/git/gitconfig_work"

# Work-specific env
export NODE_ENV=staging
export WORK_VAR="work-secret"

# Prompt tweaks
export STARSHIP_PROMPT_ORDER="directory,git_branch,git_status,nodejs,character"
