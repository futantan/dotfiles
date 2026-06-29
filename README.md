# 🛠️ dotfiles

Personal dotfiles managed with GNU Stow.

This repository manages configuration files across multiple machines
using symlinks via `stow`.

---

## 📦 Managed Modules

Each top-level directory is a module:

- `fish/` → `.config/fish/`
- `bin/` → `.local/bin/`
- `codex/` → `.codex/`
- `claude/` → `.claude/`
- `ghostty/` → `.config/ghostty/`
- `git/` → `.gitconfig`
- `nvim/` → `.config/nvim/`
- `tmux/` → `.tmux.conf`
- `zsh/` → `.zshrc`
- `zellij/` → `.config/zellij/config.kdl`

Each module mirrors the structure of `$HOME`.

Example:

tmux/.tmux.conf → ~/.tmux.conf
zellij/.config/zellij/config.kdl → ~/.config/zellij/config.kdl

Codex and Claude Code share one global agent instruction file:

codex/.codex/AGENTS.md → ~/.codex/AGENTS.md
claude/.claude/CLAUDE.md → ~/.codex/AGENTS.md

If `~/.codex/AGENTS.md` already exists as a regular file, `setup.sh` syncs it
into `codex/.codex/AGENTS.md`, backs up the original, then lets `stow` manage it.

---

## 🧩 Neovim / LazyVim

Neovim is managed as a normal dotfiles module:

```bash
~/.config/nvim -> ~/dotfiles/nvim/.config/nvim
```

Local configuration changes live in `nvim/.config/nvim/lua/config/` and
`nvim/.config/nvim/lua/plugins/`.

LazyVim and plugin updates are managed by `lazy.nvim`, not by pulling the
LazyVim starter repository:

```bash
nvim-update
```

The update command refuses to run with uncommitted Neovim config changes. After
reviewing the result, commit `nvim/.config/nvim/lazy-lock.json` and any related
config changes.

---

## 🚀 Setup on a New Machine

### 1️⃣ Clone the repository

```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
```

### 2️⃣ Run setup script

```bash
chmod +x setup.sh
./setup.sh
```

The script will:

- Check if Homebrew exists
- Install missing required packages (e.g. tmux, stow)
- Restow all modules safely

## 🔁 Updating Configuration

```bash
cd ~/dotfiles
vim tmux/.tmux.conf
git commit -am "Update tmux config"
git push
```

On other machine:

```bash
cd ~/dotfiles
git pull
./setup.sh
```

## Reference

- https://github.com/dmmulroy/.dotfiles
