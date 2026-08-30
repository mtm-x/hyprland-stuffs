#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

restore_tree() {
    local source_dir="$1"
    local target_dir="$2"

    [ -d "$source_dir" ] || return 0
    mkdir -p "$target_dir"
    # Ensure write permissions if files exist
    chmod -R u+w "$target_dir" 2>/dev/null || true
    cp -a "$source_dir/." "$target_dir/"
}

echo "--- Starting Configuration Restoration ---"

# Hyprland, Waybar & SwayNC
restore_tree "$SCRIPT_DIR/hypr_configs" "$HOME/.config/hypr"
restore_tree "$SCRIPT_DIR/waybar" "$HOME/.config/waybar"
restore_tree "$SCRIPT_DIR/swaync" "$HOME/.config/swaync"

# Terminal & Shell
restore_tree "$SCRIPT_DIR/kitty" "$HOME/.config/kitty"
restore_tree "$SCRIPT_DIR/zsh" "$HOME/.config/zsh"
restore_tree "$SCRIPT_DIR/personal_scripts" "$HOME/.config/personal_scripts"

# Protect waybar from HyDE clobbering
chmod 444 "$HOME/.config/waybar/config.jsonc" "$HOME/.config/waybar/style.css" 2>/dev/null || true

# Vim
if [ -f "$SCRIPT_DIR/vim_backup/vimrc_sonokai" ]; then
    mkdir -p "$HOME/.vim_old_backup"
    [ -f "$HOME/.vimrc" ] && cp -a "$HOME/.vimrc" "$HOME/.vim_old_backup/vimrc.bak"
    [ -d "$HOME/.vim" ] && cp -a "$HOME/.vim" "$HOME/.vim_old_backup/vim_dir.bak"
    cp -a "$SCRIPT_DIR/vim_backup/vimrc_sonokai" "$HOME/.vimrc"
    restore_tree "$SCRIPT_DIR/vim_backup/vim_dir_sonokai" "$HOME/.vim"
fi

# Fastfetch & Starship
if [ -f "$SCRIPT_DIR/fastfetch_backup/config.jsonc" ]; then
    mkdir -p "$HOME/.config/fastfetch"
    cp -a "$SCRIPT_DIR/fastfetch_backup/config.jsonc" "$HOME/.config/fastfetch/"
    restore_tree "$SCRIPT_DIR/fastfetch_backup/logo" "$HOME/.config/fastfetch/logo"
fi

if [ -f "$SCRIPT_DIR/fastfetch_backup/starship.toml" ]; then
    mkdir -p "$HOME/.config/starship"
    cp -a "$SCRIPT_DIR/fastfetch_backup/starship.toml" "$HOME/.config/starship/starship.toml"
fi

# Restart services if active
pkill -9 -f waybar.py 2>/dev/null || true
killall dunst 2>/dev/null || true
killall waybar 2>/dev/null || true
killall swaync 2>/dev/null || true
sleep 0.5
nohup waybar -c "$HOME/.config/waybar/config.jsonc" -s "$HOME/.config/waybar/style.css" >/dev/null 2>&1 & disown || true
nohup swaync >/dev/null 2>&1 & disown || true

echo "--- Configuration Restoration Complete! ---"
