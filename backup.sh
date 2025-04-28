#!/bin/bash

# Define a log file to log the output
LOG_FILE="/server/backup_log.txt"

# Add a timestamp to the log file to keep track of when backups occur
echo "Backup started at $(date)" >> "$LOG_FILE"

# Define backup directory and timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="/server/backups"

# Create the backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Backup the world directory
echo "Starting backup of /world directory..." >> "$LOG_FILE"
tar -czf "$BACKUP_DIR/world_backup_$TIMESTAMP.tar.gz" -C /server/world . >> "$LOG_FILE" 2>&1

# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "Backup completed successfully at $(date)" >> "$LOG_FILE"
else
    echo "Backup failed at $(date)" >> "$LOG_FILE"
fi

# Backup rotation: Keep only the 10 most recent backups
echo "Running backup rotation..." >> "$LOG_FILE"
ls -1t "$BACKUP_DIR"/world_backup_*.tar.gz | tail -n +11 | xargs -r rm -f >> "$LOG_FILE" 2>&1
echo "Backup rotation completed at $(date)" >> "$LOG_FILE"
