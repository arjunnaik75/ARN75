#!/bin/bash
# Script to identify directories containing 50 or more files

# Base directory to start the search, default is current directory
BASE_DIR="${1:-.}"

# Find all directories and count the number of files in each
find "$BASE_DIR" -type d | while read -r DIR; do
    FILE_COUNT=$(find "$DIR" -maxdepth 1 -type f | wc -l)
    if [ "$FILE_COUNT" -ge 50 ]; then
        echo "Directory: $DIR | Files: $FILE_COUNT" > 50plus.txt
    fi
done
