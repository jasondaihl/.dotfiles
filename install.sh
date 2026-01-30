#!/usr/bin/env bash
set -e

DOTFILES="$HOME/.dotfiles"

echo "📦 Installing Homebrew packages"
brew bundle --file="$DOTFILES/Brewfile"

echo "🔗 Linking config files"

mkdir -p ~/.config
mkdir -p "$HOME/.vim"

ln -sf "$DOTFILES/starship/starship.toml" ~/.config/starship.toml
ln -sf "$DOTFILES/vim/vimrc" "$HOME/.vimrc"

vim +PlugInstall +qall

if ! grep -q ".dotfiles/zsh/zshrc" ~/.zshrc 2>/dev/null; then
  echo "export DOTFILES=\"$DOTFILES\"" >> ~/.zshrc
  echo "source \$DOTFILES/zsh/zshrc" >> ~/.zshrc
fi

echo "✅ Done. Restart your terminal."

