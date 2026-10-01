#!/usr/bin/env bash
# Bootstrap a new Mac. Idempotent — safe to re-run.
#
# Usage:
#   ./install.sh            Full install.
#   ./install.sh --dry-run  Sandbox test: runs the filesystem steps (symlinks,
#                           ~/.zshrc hook) against a throwaway $HOME and SKIPS
#                           everything global/system-level (Homebrew, Xcode CLT,
#                           VS Code extensions, Node, and macOS defaults — the
#                           last of which ignores $HOME and would touch your real
#                           account). Nothing outside the sandbox is modified.
set -euo pipefail

DRY_RUN=false
if [[ "${1:-}" == "--dry-run" || "${1:-}" == "--sandbox" ]]; then
  DRY_RUN=true
fi

# Resolve the repo location from this script itself (not any inherited $DOTFILES),
# so it always installs this checkout and works even after $HOME is sandboxed.
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if $DRY_RUN; then
  SANDBOX="$(mktemp -d)"
  export HOME="$SANDBOX"
  echo "🧪 Dry run — \$HOME sandboxed to $SANDBOX"
  echo "   Skipping Homebrew, Xcode CLT, VS Code extensions, Node, and macOS defaults."
  echo
fi

# ---------------------------------------------------------------------------
# 1. Xcode Command Line Tools
# ---------------------------------------------------------------------------
if ! $DRY_RUN; then
  if ! xcode-select -p >/dev/null 2>&1; then
    echo "🛠  Installing Xcode Command Line Tools"
    xcode-select --install
    echo "   Finish the Xcode CLT install, then re-run ./install.sh"
    exit 0
  fi
fi

# ---------------------------------------------------------------------------
# 2. Homebrew
# ---------------------------------------------------------------------------
if ! $DRY_RUN; then
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
fi

# ---------------------------------------------------------------------------
# 3. Packages
# ---------------------------------------------------------------------------
if ! $DRY_RUN; then
  echo "📦 Installing Homebrew packages"
  brew bundle --file="$DOTFILES/Brewfile"
fi

# ---------------------------------------------------------------------------
# 4. Link config files  (runs in dry-run — lands in the sandbox $HOME)
# ---------------------------------------------------------------------------
echo "🔗 Linking config files"
mkdir -p "$HOME/.config" "$HOME/.vim"
ln -sf "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml"
ln -sf "$DOTFILES/vim/vimrc" "$HOME/.vimrc"

VSCODE_USER="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_USER"
ln -sf "$DOTFILES/vscode/settings.json" "$VSCODE_USER/settings.json"

# ---------------------------------------------------------------------------
# 5. VS Code extensions
# ---------------------------------------------------------------------------
if ! $DRY_RUN; then
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
fi

# ---------------------------------------------------------------------------
# 6. Node (default LTS + corepack for yarn/pnpm)
# ---------------------------------------------------------------------------
if ! $DRY_RUN; then
  if command -v fnm >/dev/null 2>&1; then
    echo "⬢ Installing Node LTS"
    eval "$(fnm env)"
    fnm install --lts
    fnm use --lts        # activate in this shell so node/corepack are on PATH
    fnm default "$(fnm current)"
    command -v corepack >/dev/null 2>&1 && corepack enable || true
  fi
fi

# ---------------------------------------------------------------------------
# 7. Vim plugins
# ---------------------------------------------------------------------------
if ! $DRY_RUN; then
  vim +PlugInstall +qall
fi

# ---------------------------------------------------------------------------
# 8. macOS system defaults  (skipped in dry-run: `defaults` ignores $HOME and
#    writes to the current user's real preference domains)
# ---------------------------------------------------------------------------
if ! $DRY_RUN; then
  "$DOTFILES/macos/defaults.sh"
fi

# ---------------------------------------------------------------------------
# 9. Hook dotfiles into ~/.zshrc  (runs in dry-run — lands in the sandbox $HOME)
# ---------------------------------------------------------------------------
if ! grep -q ".dotfiles/zsh/zshrc" "$HOME/.zshrc" 2>/dev/null; then
  {
    echo "export DOTFILES=\"$DOTFILES\""
    echo "source \$DOTFILES/zsh/zshrc"
  } >> "$HOME/.zshrc"
fi

if $DRY_RUN; then
  echo
  echo "✅ Dry run complete. Inspect the sandbox:"
  echo "   ls -laR $SANDBOX"
  echo "   cat $SANDBOX/.zshrc"
  echo "   Delete it when done:  rm -rf $SANDBOX"
else
  echo "✅ Done. Restart your terminal."
fi
