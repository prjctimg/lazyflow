#!/bin/bash

# This script automatically stages, commits, and (if online) pushes changes

CONFIG_DIR="$HOME/"

COMMIT_PREFIX="Dotfiles backup (🤖 automated)"

REMOTE_NAME="origin"
BRANCH_NAME="main"

# --- Pre-run Checks ---
if ! command -v git &>/dev/null; then
	exit 1
fi

cd "$CONFIG_DIR" || {
	exit 1
}

if [ ! -d ".git" ]; then
	git init
fi

# Check for uncommitted changes. If there are none, exit gracefully.
if git diff-index --quiet HEAD --; then
	exit 0
fi

git add .

COMMIT_MESSAGE="$COMMIT_PREFIX | $(date '+%Y-%m-%d %H:%M:%S')"
git commit -m "$COMMIT_MESSAGE"

# Check for an internet connection by trying to ping a reliable server.
if ping -c 1 8.8.8.8 &>/dev/null; then
	git push -u "$REMOTE_NAME" "$BRANCH_NAME"
fi
