#!/usr/bin/env bash
# @Victor-ray, S. <victorray91@pm.me> 
# https://github.com/ZendaiOwl
# 
FILE="$HOME/.bashrc"
sh -c "$(curl -fsSL https://starship.rs/install.sh --yes)"
if ! grep -q 'eval "$(starship init bash)"' "$FILE"; then
	echo 'eval "$(starship init bash)"' >> "$FILE" 
fi

exit
