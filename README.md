# dotfiles

A lightweight, fast shell environment optimized for Node.js / JavaScript development,
plus one-command provisioning for a new Mac.

## Goals
- Fast shell startup
- Minimal abstractions
- Node-aware tooling
- Reproducible new-Mac setup
- Easy to understand and remove

## Includes

**Shell / CLI:** zsh (no oh-my-zsh), starship prompt, fnm (Node), pnpm, fzf, bat, eza,
zoxide, git-delta, ripgrep, fd, lazygit, httpie, direnv, gh.

**GUI apps (via `Brewfile` casks):** VS Code, iTerm2, Chrome, Firefox, Raycast, Rectangle,
OrbStack, Figma, Bruno, and a JetBrains Mono Nerd Font.

## Installation

On a fresh Mac:

```sh
git clone https://github.com/jasondaihl/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

`install.sh` is idempotent and will:
1. Install Xcode Command Line Tools and Homebrew if missing
2. `brew bundle` all CLI tools, GUI apps, and the Nerd Font
3. Symlink configs (`starship.toml`, `vimrc`, VS Code `settings.json`)
4. Install VS Code extensions from `vscode/extensions.txt`
5. Install Node LTS via fnm and enable corepack
6. Install vim plugins
7. Apply opinionated macOS defaults (`macos/defaults.sh`)
8. Source `zsh/zshrc` from your `~/.zshrc`

Review and prune the `Brewfile` casks before running if you don't want everything.

## Profiles (personal / work)

Switch git identity + shell env together:

```sh
work        # or: personal   (aliases for `switch_profile`)
```

This persists the choice to `.current_profile`, flips `git config --global include.path`
between `git/gitconfig_personal` and `git/gitconfig_work` (both include shared
`git/gitconfig_common`), and reloads the shell. The active profile is restored on new shells.

## macOS defaults

`macos/defaults.sh` applies dev-friendly system preferences (fast key repeat, show file
extensions/hidden files, Dock + Finder tweaks, screenshots to `~/Screenshots`). It's run by
`install.sh` but is safe to run standalone and re-run. Some settings need a logout/restart.

## Maintenance

Keeping things current — the tasks that are easy to forget:

| Task | How |
| --- | --- |
| Add/remove a CLI tool or app | Edit `Brewfile`, then `brew bundle` |
| Capture ad-hoc installs into the Brewfile | `brew bundle dump --force --file=Brewfile` |
| See what's installed but *not* in the Brewfile (drift) | `brew bundle cleanup --file=Brewfile` (add `--force` to actually uninstall) |
| Add a VS Code extension | `code --list-extensions` to snapshot, add the id to `vscode/extensions.txt` |
| Bump pinned pre-commit hooks | `pre-commit autoupdate` |
| Re-apply macOS tweaks (e.g. after an OS upgrade) | `./macos/defaults.sh` |
| Change a git setting shared by both profiles | Edit `git/gitconfig_common` (not the per-profile files) |
| Lint everything before committing | `pre-commit run --all-files` |

## Why these choices

- **fnm over nvm** — much faster shell startup; `--use-on-cd` auto-switches Node per directory.
- **No oh-my-zsh** — avoids its startup cost; plugins are sourced directly in `zsh/zshrc`.
- **OrbStack over Docker Desktop** — lighter, faster, lower battery/memory use.
- **Single starship config** — starship has no include mechanism, so per-profile prompts
  aren't worth the duplication; profiles differ via git identity + shell env instead.
