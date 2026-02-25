# 🛠️ dotfiles

Personal dotfiles managed with GNU Stow.

This repository manages configuration files across multiple machines
using symlinks via `stow`.

---

## 📦 Managed Modules

Each top-level directory is a module:

- `tmux/` → `.tmux.conf`
- `nvim/` → `.config/nvim/`

Each module mirrors the structure of `$HOME`.

Example:

tmux/.tmux.conf → ~/.tmux.conf
nvim/.config/nvim/init.lua → ~/.config/nvim/init.lua

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
