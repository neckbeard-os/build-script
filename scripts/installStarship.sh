#!/bin/bash
FILE="$HOME/.bashrc"
sh -c "$(curl -fsSL https://starship.rs/install.sh --yes)"
if ! grep -q 'eval "$(starship init bash)"' "$FILE"; then
	echo 'eval "$(starship init bash)"' >> "$FILE" 
fi

exit
