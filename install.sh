#!/bin/bash

# TODO: test on a fresh system

set -e # Exit on any error

# TODO: download this repo from git and land it into Code/dotfiles

# TODO: macos & omarchy separate full system setup scripts
# For macos:
# 1. install brew
# 2. via brew install:
#   a. bash
#   b. mise
#   c. fzf
#   d. nvim
#   e. rupa/z
#   f. starship
#   g. ghostty
# 3. chsh -s bin/bash
# 4. configure git email and username
# 5. append bashrc template to .bashrc in a smart way
#   a. with a diff, when .bahsrc is already present
# 6. stow dotfiles from this repo
# 7. restart your new system, if user agrees
#

echo "🔧 Step 1: Checking required directories in \$HOME..."

# List of required directories to avoid stowing the entire thing to this repo's folder
required_dirs=(
  "$HOME/.config"
  "$HOME/.local"
)

# Check and create each directory if needed
for dir in "${required_dirs[@]}"; do
  if [ ! -d "$dir" ]; then
    echo "📁 Creating missing directory: $dir"
    mkdir -p "$dir"
  else
    echo "✅ Directory exists: $dir"
  fi
done

echo ""
echo "📦 Step 2: Stowing dotfiles..."

# Array of directories to stow
dotdirs=(alacritty wezterm tmux nvim bin ghostty)

for dir in "${dotdirs[@]}"; do
  echo "🔄 Restowing '$dir' into \$HOME"
  stow -D --target="$HOME" "$dir"
  stow --target="$HOME" "$dir"
done

echo ""
echo "🎉 All done! Dotfiles have been stowed successfully."
