#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

restore_tree() {
    local source_dir="$1"
    local target_dir="$2"

    [ -d "$source_dir" ] || return 0
    mkdir -p "$target_dir"
    cp -a "$source_dir/." "$target_dir/"
}

echo "--- Starting Configuration Restoration ---"

restore_tree "$SCRIPT_DIR/hypr_configs" "$HOME/.config/hypr"
restore_tree "$SCRIPT_DIR/kitty" "$HOME/.config/kitty"
restore_tree "$SCRIPT_DIR/zsh" "$HOME/.config/zsh"

if [ -f "$SCRIPT_DIR/vim_backup/vimrc_sonokai" ]; then
    mkdir -p "$HOME/.vim_old_backup"
    [ -f "$HOME/.vimrc" ] && cp -a "$HOME/.vimrc" "$HOME/.vim_old_backup/vimrc.bak"
    [ -d "$HOME/.vim" ] && cp -a "$HOME/.vim" "$HOME/.vim_old_backup/vim_dir.bak"
    cp -a "$SCRIPT_DIR/vim_backup/vimrc_sonokai" "$HOME/.vimrc"
    restore_tree "$SCRIPT_DIR/vim_backup/vim_dir_sonokai" "$HOME/.vim"
fi

if [ -f "$SCRIPT_DIR/fastfetch_backup/config.jsonc" ]; then
    mkdir -p "$HOME/.config/fastfetch"
    cp -a "$SCRIPT_DIR/fastfetch_backup/config.jsonc" "$HOME/.config/fastfetch/"
    restore_tree "$SCRIPT_DIR/fastfetch_backup/logo" "$HOME/.config/fastfetch/logo"
fi

if [ -f "$SCRIPT_DIR/fastfetch_backup/starship.toml" ]; then
    mkdir -p "$HOME/.config/starship"
    cp -a "$SCRIPT_DIR/fastfetch_backup/starship.toml" "$HOME/.config/starship/starship.toml"
fi

echo "--- Configuration Restoration Complete! ---"
