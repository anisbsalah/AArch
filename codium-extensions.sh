#!/bin/bash

extensions=(
	"EditorConfig.EditorConfig"
	"esbenp.prettier-vscode"
	"foxundermoon.shell-format"
	"jeff-hykin.better-nix-syntax"
	"mkhl.shfmt"
	"ph-hawkins.arc-plus"
	"PKief.material-icon-theme"
	"rogalmic.bash-debug"
	"timonwong.shellcheck"
	"trunk.io"
)

for ext in "${extensions[@]}"; do
	codium --install-extension "${ext}" --force
done
