#!/usr/bin/env bash
# apply-dual-wallpaper.sh
#
# Splits a single panoramic image across your two external monitors
# (DP-1 + HDMI-A-1) and applies it via swww. Your laptop screen (eDP-1)
# is left untouched.
#
# Usage:
#   ./apply-dual-wallpaper.sh --source /path/to/image.png   # generate crops + apply
#   ./apply-dual-wallpaper.sh --apply-only                   # just reapply saved crops
#
set -euo pipefail

# ── Configuration ────────────────────────────────────────────────
# Edit this if your monitor layout ever changes (check with: hyprctl monitors)
# Format per line: "NAME WIDTH HEIGHT X_OFFSET"
declare -a MONITORS=(
  "DP-1 1920 1080 0"
  "HDMI-A-1 1920 1080 1920"
)

TOTAL_WIDTH=3840
TOTAL_HEIGHT=1080

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
COMBINED="$WALLPAPER_DIR/combined.png"

mkdir -p "$WALLPAPER_DIR"

# ── Argument parsing ─────────────────────────────────────────────
SOURCE=""
APPLY_ONLY=false

usage() {
  echo "Usage: $0 [--source /path/to/image.png] [--apply-only]"
  echo
  echo "  --source FILE   Generate new crops from FILE, save them, then apply"
  echo "  --apply-only    Skip generation, just reapply previously saved crops"
  echo "                  (useful for autostart on login)"
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source) SOURCE="$2"; shift 2 ;;
    --apply-only) APPLY_ONLY=true; shift ;;
    -h|--help) usage ;;
    *) echo "Unknown option: $1"; usage ;;
  esac
done

# ── Generate crops (skipped with --apply-only) ──────────────────
if ! $APPLY_ONLY; then
  if [[ -z "$SOURCE" ]]; then
    echo "Error: --source is required unless using --apply-only"
    usage
  fi
  if [[ ! -f "$SOURCE" ]]; then
    echo "Error: source image not found: $SOURCE"
    exit 1
  fi
  if ! command -v magick &>/dev/null; then
    echo "Error: 'magick' command not found. Install with: sudo pacman -S imagemagick"
    exit 1
  fi

  echo "==> Building combined canvas (${TOTAL_WIDTH}x${TOTAL_HEIGHT}) from $SOURCE"
  magick "$SOURCE" -resize "${TOTAL_WIDTH}x${TOTAL_HEIGHT}^" \
    -gravity center -extent "${TOTAL_WIDTH}x${TOTAL_HEIGHT}" "$COMBINED"

  for entry in "${MONITORS[@]}"; do
    read -r name width height xoff <<< "$entry"
    out="$WALLPAPER_DIR/${name}.png"
    echo "==> Cropping slice for $name (${width}x${height}+${xoff}+0)"
    magick "$COMBINED" -crop "${width}x${height}+${xoff}+0" +repage "$out"
  done

  rm -f "$COMBINED"
  echo "==> Crops saved to $WALLPAPER_DIR"
fi

# ── Apply via swww ───────────────────────────────────────────────
if ! command -v swww &>/dev/null; then
  echo "Error: swww not found in PATH"
  exit 1
fi

if ! swww query &>/dev/null; then
  echo "==> No swww/awww daemon responding, starting one..."
  swww-daemon &
  disown
  sleep 0.5
fi

for entry in "${MONITORS[@]}"; do
  read -r name width height xoff <<< "$entry"
  img="$WALLPAPER_DIR/${name}.png"
  if [[ -f "$img" ]]; then
    echo "==> Applying wallpaper to $name"
    swww img "$img" -o "$name"
  else
    echo "Warning: no saved wallpaper found for $name at $img (run with --source first)"
  fi
done

echo "==> Done."
