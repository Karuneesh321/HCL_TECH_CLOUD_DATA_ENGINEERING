#!/bin/bash

# Check that both source and destination directories are provided
if [ "$#" -ne 2 ]; then
    echo "Error: Please provide source and destination directories."
    echo "Usage: $0 <source_directory> <destination_directory>"
    exit 1
fi

SOURCE_DIR="$1"
DEST_DIR="$2"

# Check whether the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory '$SOURCE_DIR' does not exist."
    exit 1
fi

# Create the destination directory if it does not exist
if ! mkdir -p "$DEST_DIR"; then
    echo "Error: Could not create destination directory '$DEST_DIR'."
    exit 1
fi

# Generate a timestamped compressed archive
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ARCHIVE_NAME="backup_${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="${DEST_DIR}/${ARCHIVE_NAME}"

if tar -czf "$ARCHIVE_PATH" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"; then
    echo "Backup successful!"
    echo "Archive created: $ARCHIVE_PATH"
    exit 0
else
    echo "Error: Backup failed."
    rm -f "$ARCHIVE_PATH"
    exit 1
fi