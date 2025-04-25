#!/bin/bash

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="/server/backups"  # This is where the backups will be stored
mkdir -p "$BACKUP_DIR"

# Backup the entire world directory
tar -czf "$BACKUP_DIR/world_backup_$TIMESTAMP.tar.gz" -C /server world
