#!/bin/bash

# ==============================================================================
# Git Auto-Committer for .config directory
#
# Description:
# This script automatically stages, commits, and (if online) pushes changes
# --- Configuration ---
# The directory you want to back up.
# Using "$HOME" ensures it works for any user.
CONFIG_DIR="$HOME/.config"

# The commit message. The date will be dynamically added.
COMMIT_PREFIX="Config backup (automated)"

# The remote and branch to push to.
REMOTE_NAME="origin"
BRANCH_NAME="main"

# --- Pre-run Checks ---
if ! command -v git &>/dev/null; then
	echo "Error: Git is not installed. Please install it to use this script."
	exit 1
fi

cd "$CONFIG_DIR" || {
	echo "Error: Directory $CONFIG_DIR not found."
	exit 1
}

if [ ! -d ".git" ]; then
	echo "Initializing a new Git repository in $CONFIG_DIR..."
	git init
	echo "Git repository initialized. Please add your remote repository manually."
fi

# Check for uncommitted changes. If there are none, exit gracefully.
if git diff-index --quiet HEAD --; then
	echo "No changes to commit in $CONFIG_DIR. Exiting."
	exit 0
fi

echo "Changes detected. Preparing to commit..."

git add .

COMMIT_MESSAGE="$COMMIT_PREFIX | $(date '+%Y-%m-%d %H:%M:%S')"
git commit -m "$COMMIT_MESSAGE"

# Check for an internet connection by trying to ping a reliable server.
# We use -c 1 for a single packet and &> /dev/null to suppress output.
if ping -c 1 8.8.8.8 &>/dev/null; then
	echo "Internet connection detected. Pushing to remote..."
	git push -u "$REMOTE_NAME" "$BRANCH_NAME"
	echo "Push successful."
else
	echo "No internet connection. Commit saved locally."
fi

echo "Backup script finished."
