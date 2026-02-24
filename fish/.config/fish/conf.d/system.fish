# Ensure core system commands exist even if PATH gets messed up elsewhere
fish_add_path /usr/bin /bin /usr/sbin /sbin

# Homebrew
fish_add_path /opt/homebrew/bin

# nvm node
fish_add_path ~/.local/share/nvm/v22.18.0/bin

fish_add_path ~/go/bin

fish_add_path ~/.bun/bin

fish_add_path ~/Library/pnpm

fish_add_path ~/.orbstack/bin

fish_add_path ~/.amp/bin

fish_add_path ~/.opencode/bin

fish_add_path ~/.antigravity/antigravity/bin

fish_add_path /opt/homebrew/opt/postgresql@16/bin

fish_add_path /opt/homebrew/opt/postgresql@15/bin
