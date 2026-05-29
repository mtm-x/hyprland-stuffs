#!/bin/bash

# --- Paths ---
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
VIM_BACKUP="$SCRIPT_DIR/vim_backup"
FF_BACKUP="$SCRIPT_DIR/fastfetch_backup"

echo "--- Starting Theme Restoration ---"

# 1. Restore Vim Configuration
echo "[1/2] Restoring Vim configuration..."
if [ -d "$VIM_BACKUP" ]; then
    mkdir -p "$HOME/.vim_old_backup"
    [ -f "$HOME/.vimrc" ] && cp "$HOME/.vimrc" "$HOME/.vim_old_backup/vimrc.bak"
    [ -d "$HOME/.vim" ] && cp -r "$HOME/.vim" "$HOME/.vim_old_backup/vim_dir.bak"

    cp "$VIM_BACKUP/vimrc_sonokai" "$HOME/.vimrc"
    mkdir -p "$HOME/.vim"
    cp -r "$VIM_BACKUP/vim_dir_sonokai"/* "$HOME/.vim/"

    # Ensure vim-plug and install plugins
    if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
        curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
    vim +PlugInstall +qall
else
    echo "Skipping Vim: Backup not found."
fi

# 2. Restore Fastfetch Configuration
echo "[2/2] Restoring Fastfetch configuration..."
if [ -d "$FF_BACKUP" ]; then
    mkdir -p "$HOME/.config/fastfetch"
    cp "$FF_BACKUP/config.jsonc" "$HOME/.config/fastfetch/"
    cp -r "$FF_BACKUP/logo" "$HOME/.config/fastfetch/"
else
    echo "Skipping Fastfetch: Backup not found."
fi

echo "--- Restoration Complete! ---"
