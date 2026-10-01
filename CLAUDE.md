# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Personal dotfiles for a fast, Node-focused zsh environment on macOS (Homebrew). No build step — these are config files sourced at shell startup.

## Commands

- `./install.sh` — bootstrap: `brew bundle`, symlink configs, run `vim +PlugInstall`, and append the zshrc source line to `~/.zshrc`. Idempotent (guards against duplicate source lines).
- `pre-commit run --all-files` — run the linters (shellcheck, editorconfig-checker, YAML/JSON/TOML checks, whitespace fixers). This is the only "test"/CI gate. Config in `.pre-commit-config.yaml`.
- `reload` (alias) — re-source `~/.zshrc` after editing shell configs.
- `bin/dev-reset` — nukes `node_modules` + lockfiles and reinstalls (per-project helper, not dotfiles-related).

Shellcheck runs with `--shell=bash`, but the shell scripts are zsh; keep zsh-isms behind `# shellcheck disable=` directives as done in `zsh/fzf.zsh`.

## Architecture

`zsh/zshrc` is the single entrypoint. `install.sh` does NOT symlink it — it appends `export DOTFILES` + `source $DOTFILES/zsh/zshrc` to the user's real `~/.zshrc`. `zshrc` then sources the modular files in `zsh/` (`aliases`, `node`, `fzf`, `keybindings`). Only `starship/starship.toml` and `vim/vimrc` are symlinked into place.

### Profile system (the non-obvious part)

Two independent mechanisms both keyed on "personal" vs "work":

1. **Shell env profile** — `DOTFILES_PROFILE` (defaults to `personal`) selects which file `zsh/profiles/${DOTFILES_PROFILE}.zsh` gets sourced and which `starship/starship_${DOTFILES_PROFILE}.toml` is used as `STARSHIP_CONFIG`. Set `DOTFILES_PROFILE` before the shell loads to switch.
2. **Git identity profile** — the `switch_profile` function (and the `personal`/`work` aliases) swap `git config --global include.path` between `git/gitconfig_personal` and `git/gitconfig_work`. This is runtime and separate from `DOTFILES_PROFILE`.

Both profile files must be named `profiles/<name>.zsh` — `zshrc` only sources `profiles/${DOTFILES_PROFILE}.zsh`, so a differently-suffixed file (e.g. `.sh`) silently won't load.

### Tooling assumptions

Everything in `Brewfile` must be installed or `zshrc` errors on startup: `fnm` (Node version mgmt, `--use-on-cd`), `starship`, `zoxide`, `direnv`, `git-delta`, plus the zsh plugins `zsh-autosuggestions` and `zsh-syntax-highlighting` (sourced from `$(brew --prefix)/share/...`). Aliases also assume `eza`, `bat`. Node defaults live in `zsh/node.zsh` (`NODE_ENV`, `NODE_OPTIONS` heap size, npm/pnpm aliases).
