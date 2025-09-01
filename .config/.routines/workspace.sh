#! /bin/env bash

# The directory where your Git repositories are located.
WORKSPACE_DIR="/home/prjctimg/workspace/"

# The directory where the backups will be stored.
# Ensure this directory exists and the script has write permissions.
BACKUP_DIR="/tmp/workspace_backup"

# This will include a timestamp to make each backup unique.
ARCHIVE_NAME="workspace_snapshot-$(date +%Y%m%d_%H%M%S).tar.gz"

# Temporary directory to store individual git bundles before archiving.
TEMP_BUNDLE_DIR="${BACKUP_DIR}/git_bundles"

echo "Starting workspace backup routine for $(date)"
echo "Workspace directory: ${WORKSPACE_DIR}"
echo "Backup destination: ${BACKUP_DIR}"

# Create backup directory if it doesn't exist
mkdir -p "${BACKUP_DIR}" || {
	echo "Error: Could not create backup directory ${BACKUP_DIR}. Exiting."
	exit 1
}

# Create temporary bundle directory
mkdir -p "${TEMP_BUNDLE_DIR}" || {
	echo "Error: Could not create temporary bundle directory ${TEMP_BUNDLE_DIR}. Exiting."
	exit 1
}

# Find all Git repositories and create bundles
find "${WORKSPACE_DIR}" -type d -name ".git" | while read -r GIT_DIR; do
	# Get the parent directory of .git (which is the repository root)
	REPO_PATH=$(dirname "${GIT_DIR}")
	# Extract the repository name for the bundle file
	REPO_NAME=$(basename "${REPO_PATH}")

	# Construct the full path for the bundle file
	BUNDLE_FILE="${TEMP_BUNDLE_DIR}/${REPO_NAME}.bundle"

	echo "Backing up repository: ${REPO_PATH} to ${BUNDLE_FILE}"

	# Change to the repository directory to create the bundle
	(cd "${REPO_PATH}" && git bundle create "${BUNDLE_FILE}" --all) || {
		echo "Warning: Failed to create bundle for ${REPO_PATH}. Skipping."
	}
done

# Check if any bundles were created
if [ -z "$(ls -A "${TEMP_BUNDLE_DIR}")" ]; then
	echo "No Git repositories found or no bundles were created. Exiting."
	rmdir "${TEMP_BUNDLE_DIR}" # Remove empty temp directory
	exit 0
fi

echo "Creating archive: ${BACKUP_DIR}/${ARCHIVE_NAME}"

# Create a compressed tar archive of all bundle files
# -C "${TEMP_BUNDLE_DIR}" changes to the directory before archiving,
# so the archive contains just the bundle files, not the full path.
tar -czf "${BACKUP_DIR}/${ARCHIVE_NAME}" -C "${TEMP_BUNDLE_DIR}" . || {
	echo "Error: Failed to create archive ${ARCHIVE_NAME}. Exiting."
	rm -rf "${TEMP_BUNDLE_DIR}" # Clean up even on error
	exit 1
}

echo "Backup successful! Archive saved to: ${BACKUP_DIR}/${ARCHIVE_NAME}"

# Clean up temporary bundle files
echo "Cleaning up temporary bundle directory: ${TEMP_BUNDLE_DIR}"
rm -rfv "${TEMP_BUNDLE_DIR}"

echo "Backup process completed."
