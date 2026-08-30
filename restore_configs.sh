#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# ANSI Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[*]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[!]${NC} $1"
}

restore_tree() {
    local source_dir="$1"
    local target_dir="$2"
    local label="${3:-$target_dir}"

    if [ -d "$source_dir" ]; then
        mkdir -p "$target_dir"
        chmod -R u+w "$target_dir" 2>/dev/null || true
        cp -a "$source_dir/." "$target_dir/"
        log_success "Restored: ${CYAN}$label${NC}"
    fi
}

echo -e "\n${BLUE}==============================================${NC}"
echo -e "${BLUE}   Personal Desktop Configuration Restorer    ${NC}"
echo -e "${BLUE}==============================================${NC}\n"

log_info "Deploying user configurations..."

# 1. Desktop & Window Manager
restore_tree "$SCRIPT_DIR/hypr_configs" "$HOME/.config/hypr" "Hyprland configs (theme, binds, rules, animations)"
restore_tree "$SCRIPT_DIR/waybar" "$HOME/.config/waybar" "Waybar floating top bar"
restore_tree "$SCRIPT_DIR/swaync" "$HOME/.config/swaync" "SwayNC notification center"
restore_tree "$SCRIPT_DIR/clipse" "$HOME/.config/clipse" "Clipse clipboard manager"
restore_tree "$SCRIPT_DIR/rofi" "$HOME/.config/rofi" "Rofi application launcher"

# 2. Terminal, Shell & Scripts
restore_tree "$SCRIPT_DIR/kitty" "$HOME/.config/kitty" "Kitty terminal configuration"
restore_tree "$SCRIPT_DIR/zsh" "$HOME/.config/zsh" "Zsh shell configuration"
restore_tree "$SCRIPT_DIR/personal_scripts" "$HOME/.config/personal_scripts" "Personal utility scripts (hypr-profile, setwall)"

# 3. Protect Waybar from automated overwrites
chmod 444 "$HOME/.config/waybar/config.jsonc" "$HOME/.config/waybar/style.css" 2>/dev/null || true
log_success "Applied write-protection to Waybar configs"

# 4. Vim setup
if [ -f "$SCRIPT_DIR/vim_backup/vimrc_sonokai" ]; then
    rm -rf "$HOME/.vim_old_backup" 2>/dev/null || true
    mkdir -p "$HOME/.vim_old_backup"
    [ -f "$HOME/.vimrc" ] && cp -a "$HOME/.vimrc" "$HOME/.vim_old_backup/vimrc.bak"
    [ -d "$HOME/.vim" ] && cp -a "$HOME/.vim" "$HOME/.vim_old_backup/vim_dir.bak"
    cp -a "$SCRIPT_DIR/vim_backup/vimrc_sonokai" "$HOME/.vimrc"
    restore_tree "$SCRIPT_DIR/vim_backup/vim_dir_sonokai" "$HOME/.vim" "Vim plugins and config"
fi

# 5. Fastfetch (commented out) & Starship
# if [ -f "$SCRIPT_DIR/fastfetch_backup/config.jsonc" ]; then
#     mkdir -p "$HOME/.config/fastfetch"
#     cp -a "$SCRIPT_DIR/fastfetch_backup/config.jsonc" "$HOME/.config/fastfetch/"
#     restore_tree "$SCRIPT_DIR/fastfetch_backup/logo" "$HOME/.config/fastfetch/logo" "Fastfetch config & logos"
# fi

if [ -f "$SCRIPT_DIR/fastfetch_backup/starship.toml" ]; then
    mkdir -p "$HOME/.config/starship"
    cp -a "$SCRIPT_DIR/fastfetch_backup/starship.toml" "$HOME/.config/starship/starship.toml"
    log_success "Restored: ${CYAN}Starship prompt config${NC}"
fi

# 6. Service Management
echo ""
log_info "Restarting desktop services..."

killall -9 dunst 2>/dev/null || true

if systemctl --user is-active hyde-Hyprland-bar.service &>/dev/null; then
    systemctl --user restart hyde-Hyprland-bar.service
    log_success "Waybar restarted via systemd"
else
    killall -9 waybar 2>/dev/null || true
    sleep 0.3
    nohup waybar >/dev/null 2>&1 & disown || true
    log_success "Waybar restarted standalone"
fi

killall -9 swaync 2>/dev/null || true
sleep 0.3
nohup swaync >/dev/null 2>&1 & disown || true
log_success "SwayNC notification center restarted"

# 7. Reload Hyprland
if command -v hyprctl &>/dev/null; then
    hyprctl reload >/dev/null 2>&1 || true
    log_success "Hyprland configuration reloaded"
fi

echo -e "\n${GREEN}==============================================${NC}"
echo -e "${GREEN}   Configuration Restoration Completed!      ${NC}"
echo -e "${GREEN}==============================================${NC}\n"
