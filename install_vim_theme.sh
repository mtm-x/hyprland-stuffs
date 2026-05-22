#!/bin/bash

# --- Paths ---
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
BACKUP_DIR="$SCRIPT_DIR/vim_backup"
VIMRC_SRC="$BACKUP_DIR/vimrc_sonokai"
VIMDIR_SRC="$BACKUP_DIR/vim_dir_sonokai"

DEST_VIMRC="$HOME/.vimrc"
DEST_VIMDIR="$HOME/.vim"

echo "--- Starting Vim Theme Installation ---"

# 1. Backup existing config if it exists
if [ -f "$DEST_VIMRC" ] || [ -d "$DEST_VIMDIR" ]; then
    echo "Backing up current Vim config to ~/.vim_old_backup..."
    mkdir -p "$HOME/.vim_old_backup"
    [ -f "$DEST_VIMRC" ] && cp "$DEST_VIMRC" "$HOME/.vim_old_backup/vimrc.bak"
    [ -d "$DEST_VIMDIR" ] && cp -r "$DEST_VIMDIR" "$HOME/.vim_old_backup/vim_dir.bak"
fi

# 2. Copy the Sonokai configuration
echo "Applying Sonokai configuration..."
cp "$VIMRC_SRC" "$DEST_VIMRC"
mkdir -p "$DEST_VIMDIR"
if [ -d "$VIMDIR_SRC" ]; then
    cp -r "$VIMDIR_SRC"/* "$DEST_VIMDIR/"
fi

# 3. Ensure vim-plug is installed
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    echo "Installing vim-plug..."
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# 4. Install Plugins
echo "Installing plugins via Vim (this might take a moment)..."
vim +PlugInstall +qall

echo "--- Installation Complete! ---"
echo "You can now open Vim and enjoy your Sonokai theme."
