#!/bin/bash

# Define the target configuration file
CONFIG_FILE="$HOME/.config/hypr/monitors.conf"

case "$1" in
--desk | -d)
  echo "Applying Desk (Standard) Monitor Configuration..."
  cat <<'EOF' >"$CONFIG_FILE"
# Left Monitor (DisplayPort)
monitor=desc:LG Electronics LG IPS FULLHD 201PMZR063837, preferred, 0x0, 1

# Middle Monitor (Standard Desk HDMI)
# Starts at 1920
monitor=desc:LG Electronics LG IPS FULLHD 0x01010101, preferred, 1920x0, 1

# Right Monitor / Laptop (eDP)
# Starts at 3840
monitor=desc:Lenovo Group Limited 0x403D, preferred, 3840x0, 1
EOF
  ;;

--tv | -t)
  echo "Applying TV (4K Scaled) Monitor Configuration..."
  cat <<'EOF' >"$CONFIG_FILE"
# Left Monitor (DisplayPort)
monitor=desc:LG Electronics LG IPS FULLHD 201PMZR063837, 1920x1080@60.00, 0x0, 1

# Middle Monitor (4K TV via HDMI)
# Scaled by 2 so it logically acts as 1920px wide
monitor=desc:SKYDATA S.P.A. TV MONITOR 0x00000001, 3840x2160@60.00, 1920x0, 2

# Right Monitor / Laptop (eDP)
# Starts at 3840 because the scaled TV acts as 1920px wide
monitor=desc:Lenovo Group Limited 0x403D, 1920x1200@60.026, 3840x0, 1
EOF
  ;;

*)
  echo "Error: Invalid or missing flag."
  echo "Usage: $0 [--desk | --tv]"
  echo "  --desk, -d   Apply your standard desk layout"
  echo "  --tv,   -t   Apply the 4K TV layout"
  exit 1
  ;;
esac

# Force Hyprland to reload the config to apply changes immediately
hyprctl reload

echo "Monitor setup updated successfully!"
