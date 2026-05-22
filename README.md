# Vim Sonokai Theme Installation

This folder contains the backup and installation script for the high-contrast Sonokai Vim theme setup, customized for the Graphite Mono / Grukai environment.

## 🚀 Automated Installation (Recommended)

To quickly restore your Vim configuration, run the provided installation script:

```bash
chmod +x install_vim_theme.sh
./install_vim_theme.sh
```

**What this script does:**
1. Backs up your existing `.vimrc` and `.vim/` to `~/.vim_old_backup/`.
2. Restores the Sonokai `.vimrc` and plugin directory.
3. Automatically installs `vim-plug` if not present.
4. Triggers a headless plugin installation.

---

## 🛠 Manual Installation

If you prefer to do it yourself, follow these steps:

1. **Copy the Configuration Files:**
   ```bash
   cp vim_backup/vimrc_sonokai ~/.vimrc
   cp -r vim_backup/vim_dir_sonokai/* ~/.vim/
   ```

2. **Install vim-plug (if missing):**
   ```bash
   curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
   ```

3. **Install Plugins:**
   Open Vim and run:
   ```vim
   :PlugInstall
   ```

---

## ✨ Key Features of This Setup

- **Theme:** Sonokai (Atlantis style) - High contrast and vibrant.
- **Transparency:** Custom `AdaptToTerminal()` function ensures Vim, the StatusLine, and the built-in `:terminal` match your Kitty terminal background.
- **Indentation:** Strict **Linux Kernel style** (8-character tabs, no spaces).
- **Highlighting:** Enhanced `MatchParen` (brackets) with a bright orange background for high visibility.
- **UI:** Includes Lightline (status bar), NERDTree (file explorer), CtrlP (fuzzy finder), and EasyMotion.

---

## ⌨️ Custom Keybindings

- `Ctrl + n`: Toggle NERDTree sidebar.
- `Ctrl + f`: Find current file in NERDTree.
- `Ctrl + p`: Fuzzy file search.
