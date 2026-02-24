#!/usr/bin/env bash

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🚀 Starting dotfiles setup..."

# ------------------------------
# 1️⃣ Check Homebrew
# ------------------------------

if ! command -v brew &> /dev/null; then
  echo "⚠️  Homebrew not found."
  echo "Please install Homebrew first: https://brew.sh/"
  exit 1
fi

echo "✅ Homebrew found"

# ------------------------------
# 2️⃣ Ensure required packages
# ------------------------------

REQUIRED_PACKAGES=(
  tmux
  stow
)

for pkg in "${REQUIRED_PACKAGES[@]}"; do
  if brew list "$pkg" &>/dev/null; then
    echo "✅ $pkg already installed"
  else
    echo "📦 Installing $pkg..."
    brew install "$pkg"
  fi
done

# ------------------------------
# 3️⃣ Stow all modules
# ------------------------------

cd "$DOTFILES_DIR"

echo "🔗 Stowing modules..."

for dir in */ ; do
  # 跳过非模块目录
  if [[ "$dir" == ".git/" ]]; then
    continue
  fi

  module="${dir%/}"
  echo "➡️  Stowing $module"
  stow -R "$module"
done

# ------------------------------
# 4️⃣ macOS App Defaults
# ------------------------------

if [[ "$(uname -s)" == "Darwin" ]]; then
  echo "⚙️  Configuring Antigravity key repeat behavior..."
  defaults write com.google.antigravity ApplePressAndHoldEnabled -bool false
  defaults delete -g ApplePressAndHoldEnabled
  echo "✅ Antigravity: ApplePressAndHoldEnabled = false"
else
  echo "⚠️  Skipping macOS-specific defaults on non-macOS system"
fi

echo "🎉 Dotfiles setup complete!"
