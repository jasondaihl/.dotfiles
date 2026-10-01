# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Personal dotfiles for a fast, Node-focused zsh environment on macOS (Homebrew). No build step — these are config files sourced at shell startup.

## Commands

- `./install.sh` — full new-Mac bootstrap: installs Xcode CLT + Homebrew if missing, `brew bundle`, symlinks configs, installs VS Code extensions, installs Node LTS via fnm + corepack, runs `vim +PlugInstall`, applies `macos/defaults.sh`, and appends the zshrc source line to `~/.zshrc`. Idempotent.
- `./install.sh --dry-run` — sandbox test: runs only the filesystem steps (symlinks + `~/.zshrc` hook) against a throwaway `$HOME`, skipping brew/Xcode/extensions/Node/macOS-defaults. Use this to validate install logic without mutating the machine. (`macos/defaults.sh` is skipped in dry-run because `defaults write` ignores `$HOME`.)
- `macos/defaults.sh` — opinionated macOS system prefs (`defaults write`). Safe to run standalone and re-run.
- `pre-commit run --all-files` — run the linters (shellcheck, editorconfig-checker, YAML/JSON/TOML checks, whitespace fixers). This is the only "test"/CI gate. Config in `.pre-commit-config.yaml`.
- `reload` (alias) — re-source `~/.zshrc` after editing shell configs.
- `bin/dev-reset` — nukes `node_modules` + lockfiles and reinstalls (per-project helper, not dotfiles-related).

Shellcheck runs with `--shell=bash`, but the shell scripts are zsh; keep zsh-isms behind `# shellcheck disable=` directives as done in `zsh/fzf.zsh`.

## Architecture

`zsh/zshrc` is the single entrypoint. `install.sh` does NOT symlink it — it appends `export DOTFILES` + `source $DOTFILES/zsh/zshrc` to the user's real `~/.zshrc`. `zshrc` then sources the modular files in `zsh/` (`aliases`, `node`, `fzf`, `keybindings`). Symlinked into place by `install.sh`: `starship/starship.toml` → `~/.config/starship.toml`, `vim/vimrc` → `~/.vimrc`, `vscode/settings.json` → the VS Code User dir.

### Profile system

One function unifies both profile concerns. `switch_profile {personal|work}` (with `personal`/`work` aliases in `aliases.zsh`) does three things: writes the choice to `$DOTFILES/.current_profile` (gitignored), flips `git config --global include.path` between `git/gitconfig_personal` and `git/gitconfig_work`, and `exec zsh` to reload. On startup `zshrc` reads `.current_profile` (env override wins, fallback `personal`) into `DOTFILES_PROFILE`, then sources `zsh/profiles/${DOTFILES_PROFILE}.zsh`. So git identity and shell env now switch together and persist across shells.

Git configs are layered: `gitconfig_personal`/`gitconfig_work` hold only `[user]` identity and `[include]` the shared `git/gitconfig_common` (editor, delta, push, branch, color). Edit shared settings in `gitconfig_common`.

Starship uses a single config (`starship/starship.toml`); there is no per-profile prompt (starship has no config include mechanism).

### Tooling assumptions

Everything in `Brewfile` must be installed or `zshrc` errors on startup: `fnm` (Node version mgmt, `--use-on-cd`), `starship`, `zoxide`, `direnv`, `git-delta`, plus the zsh plugins `zsh-autosuggestions` and `zsh-syntax-highlighting` (sourced from `$(brew --prefix)/share/...`). Aliases assume `eza`, `bat`. The `--icons`/prompt glyphs require the JetBrains Mono Nerd Font (installed via Brewfile cask). `NODE_ENV` is intentionally NOT exported globally — it belongs in per-project `.envrc` (direnv); `zsh/node.zsh` only sets `NODE_OPTIONS` + npm/pnpm aliases.
