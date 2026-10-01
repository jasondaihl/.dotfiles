#!/usr/bin/env bash
# Bootstrap a new Mac. Idempotent — safe to re-run.
set -euo pipefail

DOTFILES="$HOME/.dotfiles"

# ---------------------------------------------------------------------------
# 1. Xcode Command Line Tools
# ---------------------------------------------------------------------------
if ! xcode-select -p >/dev/null 2>&1; then
  echo "🛠  Installing Xcode Command Line Tools"
  xcode-select --install
  echo "   Finish the Xcode CLT install, then re-run ./install.sh"
  exit 0
fi

# ---------------------------------------------------------------------------
# 2. Homebrew
# ---------------------------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  echo "🍺 Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Ensure brew is on PATH for this session (Apple Silicon or Intel location).
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# ---------------------------------------------------------------------------
# 3. Packages
# ---------------------------------------------------------------------------
echo "📦 Installing Homebrew packages"
brew bundle --file="$DOTFILES/Brewfile"

# ---------------------------------------------------------------------------
# 4. Link config files
# ---------------------------------------------------------------------------
echo "🔗 Linking config files"
mkdir -p ~/.config "$HOME/.vim"
ln -sf "$DOTFILES/starship/starship.toml" ~/.config/starship.toml
ln -sf "$DOTFILES/vim/vimrc" "$HOME/.vimrc"

VSCODE_USER="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_USER"
ln -sf "$DOTFILES/vscode/settings.json" "$VSCODE_USER/settings.json"

# ---------------------------------------------------------------------------
# 5. VS Code extensions
# ---------------------------------------------------------------------------
if command -v code >/dev/null 2>&1; then
  echo "🧩 Installing VS Code extensions"
  while IFS= read -r ext; do
    [ -z "$ext" ] && continue
    code --install-extension "$ext" --force || echo "⚠️  failed to install: $ext"
  done < "$DOTFILES/vscode/extensions.txt"
else
  echo "⚠️  'code' CLI not found — skipping VS Code extensions."
  echo "   Open VS Code and run 'Shell Command: Install code command in PATH', then re-run."
fi

# ---------------------------------------------------------------------------
# 6. Node (default LTS + corepack for yarn/pnpm)
# ---------------------------------------------------------------------------
if command -v fnm >/dev/null 2>&1; then
  echo "⬢ Installing Node LTS"
  eval "$(fnm env)"
  fnm install --lts
  fnm use --lts        # activate in this shell so node/corepack are on PATH
  fnm default "$(fnm current)"
  command -v corepack >/dev/null 2>&1 && corepack enable || true
fi

# ---------------------------------------------------------------------------
# 7. Vim plugins
# ---------------------------------------------------------------------------
vim +PlugInstall +qall

# ---------------------------------------------------------------------------
# 8. macOS system defaults
# ---------------------------------------------------------------------------
"$DOTFILES/macos/defaults.sh"

# ---------------------------------------------------------------------------
# 9. Hook dotfiles into ~/.zshrc
# ---------------------------------------------------------------------------
if ! grep -q ".dotfiles/zsh/zshrc" ~/.zshrc 2>/dev/null; then
  {
    echo "export DOTFILES=\"$DOTFILES\""
    echo "source \$DOTFILES/zsh/zshrc"
  } >> ~/.zshrc
fi

echo "✅ Done. Restart your terminal."
