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
