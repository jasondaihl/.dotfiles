#!/usr/bin/env bash
set -e

DOTFILES="$HOME/.dotfiles"

echo "📦 Installing Homebrew packages"
brew bundle --file="$DOTFILES/Brewfile"

echo "🔗 Linking config files"

mkdir -p ~/.config

ln -sf "$DOTFILES/git/gitconfig" ~/.gitconfig
ln -sf "$DOTFILES/starship/starship.toml" ~/.config/starship.toml

if ! grep -q ".dotfiles/zsh/zshrc" ~/.zshrc 2>/dev/null; then
  echo "" >> ~/.zshrc
  echo "# Dotfiles" >> ~/.zshrc
  echo "export DOTFILES=\"$DOTFILES\"" >> ~/.zshrc
  echo "source \$DOTFILES/zsh/zshrc" >> ~/.zshrc
fi

echo "✅ Done. Restart your terminal."

