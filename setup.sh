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

while IFS= read -r line || [[ -n "$line" ]]; do
  # strip inline comments and trim whitespace
  line="${line%%#*}"
  line="${line#"${line%%[![:space:]]*}"}"
  line="${line%"${line##*[![:space:]]}"}"
  [[ -z "$line" ]] && continue
  if [[ "$line" =~ ^brew\ +\"(.+)\" ]]; then
    pkg="${BASH_REMATCH[1]}"
    if brew list --formula "$pkg" &>/dev/null; then
      echo "✅ $pkg already installed"
    else
      echo "📦 Installing $pkg..."
      echo "➜ brew install $pkg"
      brew install "$pkg"
    fi
  elif [[ "$line" =~ ^cask\ +\"(.+)\" ]]; then
    pkg="${BASH_REMATCH[1]}"
    if brew list --cask "$pkg" &>/dev/null; then
      echo "✅ $pkg already installed (cask)"
    elif [[ "$pkg" == "font-fira-code-nerd-font" ]] && compgen -G "$HOME/Library/Fonts/FiraCodeNerdFont*.ttf" >/dev/null; then
      echo "✅ $pkg fonts already present"
    else
      echo "📦 Installing $pkg (cask)..."
      echo "➜ brew install --cask $pkg"
      brew install --cask "$pkg"
    fi
  fi
done < "$DOTFILES_DIR/packages.txt"

# ------------------------------
# 3️⃣ Prepare stow-managed files
# ------------------------------

migrate_existing_codex_agents() {
  local source target backup

  source="$DOTFILES_DIR/codex/.codex/AGENTS.md"
  target="$HOME/.codex/AGENTS.md"

  [[ -f "$source" ]] || return 0
  [[ -e "$target" || -L "$target" ]] || return 0

  if [[ "$target" -ef "$source" ]]; then
    echo "✅ Codex AGENTS.md already managed by dotfiles"
    return 0
  fi

  if [[ -L "$target" ]]; then
    echo "✅ Codex AGENTS.md already linked"
    return 0
  fi

  if [[ ! -f "$target" ]]; then
    echo "⚠️  $target exists but is not a regular file; skipping automatic migration"
    return 0
  fi

  if cmp -s "$target" "$source"; then
    echo "✅ Existing Codex AGENTS.md matches dotfiles"
  else
    echo "📝 Syncing existing Codex AGENTS.md into dotfiles"
    cp "$target" "$source"
  fi

  backup="$target.bak.$(date +%Y%m%d%H%M%S)"
  while [[ -e "$backup" ]]; do
    backup="$target.bak.$(date +%Y%m%d%H%M%S)-$RANDOM"
  done

  mv "$target" "$backup"
  echo "📦 Backed up previous Codex AGENTS.md to $backup"
}

migrate_existing_codex_agents

# ------------------------------
# 4️⃣ Stow all modules
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
# 5️⃣ macOS App Defaults
# ------------------------------

if [[ "$(uname -s)" == "Darwin" ]]; then
  echo "⚙️  Configuring Antigravity key repeat behavior..."
  defaults write com.google.antigravity ApplePressAndHoldEnabled -bool false
  defaults delete -g ApplePressAndHoldEnabled 2>/dev/null || true
  echo "✅ Antigravity: ApplePressAndHoldEnabled = false"
else
  echo "⚠️  Skipping macOS-specific defaults on non-macOS system"
fi

echo "🎉 Dotfiles setup complete!"
