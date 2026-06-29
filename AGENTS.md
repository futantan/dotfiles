# Repository Guidelines

## Project Structure & Module Organization

This is a GNU Stow-managed dotfiles repository. Each top-level directory is a stow module that mirrors its target path under `$HOME`.

- `fish/`, `zsh/`: shell configuration.
- `nvim/`: LazyVim-based Neovim configuration and lockfile.
- `tmux/`, `zellij/`, `ghostty/`: terminal and multiplexer configuration.
- `git/`: global Git configuration.
- `bin/`: user scripts installed under `~/.local/bin`.
- `codex/`, `claude/`: agent configuration and helper scripts.

There is no application source tree or test suite; most changes are configuration edits.

## Build, Test, and Development Commands

- `./setup.sh`: installs required Homebrew packages from `packages.txt`, migrates existing Codex agent instructions when needed, and applies all configuration by restowing modules.
- `stow -R <module>`: restows a single module, for example `stow -R fish`.
- `fish -n fish/.config/fish/config.fish`: checks fish syntax.
- `zsh -n zsh/.zshrc`: checks zsh syntax.
- `nvim-update`: updates LazyVim plugins and refuses to run when Neovim config has uncommitted changes.

Run targeted syntax checks for the files you changed before committing. Apply configuration changes through `./setup.sh`; do not manually edit files under `$HOME` or restow modules ad hoc unless the user explicitly asks.

## Coding Style & Naming Conventions

Keep shell scripts POSIX/Bash-readable unless the file is explicitly fish or zsh. Use clear command names in `bin/.local/bin/`, preferably lowercase with hyphens. Keep configuration changes minimal and grouped by module. Avoid machine-specific absolute paths unless they are already part of the managed configuration.

## Testing Guidelines

Validate configuration with the native tool when possible: shell `-n` checks for shell files, `git diff --check` for whitespace, and app-specific reloads for tmux, fish, Ghostty, or Neovim. For `setup.sh`, prefer small, reviewable changes because it mutates the user environment through Homebrew and Stow.

## Commit & Pull Request Guidelines

Recent history uses short messages, often Conventional Commit style when useful, such as `feat(nvim): ...` or `fix(nvim): ...`. Prefer concise, scoped commits that describe the module changed. Pull requests should explain the affected module, list manual verification commands, and include screenshots only for visual terminal/editor changes.

## Agent-Specific Instructions

Do not overwrite an existing root `AGENTS.md`. Preserve user-local changes and avoid destructive Git commands. Configuration changes must be made in this repository's module files, then applied with `./setup.sh`; do not manually edit target dotfiles such as `~/.config/fish/config.fish`, `~/.tmux.conf`, or `~/.codex/AGENTS.md`. For manual file edits inside the repo, prefer small patches and keep dotfile behavior explicit.
