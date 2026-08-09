#!/usr/bin/env bash
# Simple wallpaper setter for HyDE
# Usage: ./setwall.sh /path/to/wallpaper.jpg

WALLPAPER="$1"

if [ -z "$WALLPAPER" ]; then
    echo "Usage: $0 /path/to/wallpaper"
    exit 1
fi

if [ ! -f "$WALLPAPER" ]; then
    echo "File not found: $WALLPAPER"
    exit 1
fi

# Resolve HyDE paths
HYDE_THEME_DIR="${HYDE_THEME_DIR:-$HOME/.config/hyde/themes/$(cat "$HOME/.config/hyde/theme.ctl" 2>/dev/null | head -1 | cut -d'|' -f2 | xargs)}"
HYDE_THEME_DIR="${HYDE_THEME_DIR:-$HOME/.config/hyde/themes/$(ls -1 "$HOME/.config/hyde/themes" 2>/dev/null | head -1)}"
HYDE_CACHE_HOME="${HYDE_CACHE_HOME:-$HOME/.cache/hyde}"

WALL_SET="$HYDE_THEME_DIR/wall.set"
WALL_CUR="$HYDE_CACHE_HOME/wall.set"

# Get absolute path
WALLPAPER="$(realpath "$WALLPAPER")"

# Update HyDE's current wallpaper symlink
rm -f "$WALL_SET"
ln -sf "$WALLPAPER" "$WALL_SET"

# Update cache copy
mkdir -p "$HYDE_CACHE_HOME"
cp -f "$WALLPAPER" "$WALL_CUR" 2>/dev/null || ln -sf "$WALLPAPER" "$WALL_CUR"

# Try swww first, then hyprpaper, then feh, then hyprctl
if command -v swww &>/dev/null; then
    swww img "$WALLPAPER" --transition-type any --transition-duration 1.5
    echo "Set via swww"
elif command -v hyprpaper &>/dev/null; then
    hyprctl hyprpaper preload "$WALLPAPER"
    hyprctl hyprpaper wallpaper ", $WALLPAPER"
    echo "Set via hyprpaper"
elif command -v feh &>/dev/null; then
    feh --bg-fill "$WALLPAPER"
    echo "Set via feh"
else
    echo "No wallpaper backend found (tried: swww, hyprpaper, feh)"
    echo "But wall.set symlink updated at: $WALL_SET"
fi

# Optional: regenerate thumbnails/cache if hyde cache script exists
if [ -f "$HOME/.local/lib/hyde/wallpaper/cache.sh" ]; then
    "$HOME/.local/lib/hyde/wallpaper/cache.sh" commence -w "$WALLPAPER" &>/dev/null &
fi

echo "Done: $WALLPAPER"
