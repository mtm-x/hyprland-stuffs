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

restore_tree "$SCRIPT_DIR/personal_scripts" "$HOME/.config/personal_scripts"
restore_tree "$SCRIPT_DIR/scripts" "$HOME/.config/scripts"

echo "--- Script Restoration Complete! ---"
