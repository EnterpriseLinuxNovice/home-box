#!/usr/bin/env bash

#Src, Dest, & Log vars
SOURCE_DIR=(
"boot"
"data"
"etc"
"home"
"opt"
"root"
"usr"
"var"
)
DATE=$(date +'%Y-%m-%d')
DEST_DIR="/backup/backups"
LOG_FILE="/backup/backuplog.log"

# Ensure file exists
mkdir -p "$DEST_DIR"
touch "$LOG_FILE"

echo "$DATE :: Initializing Backup script on server." >> "$LOG_FILE"
for SRC in "${SOURCE_DIR[@]}"; do
	DEST="$DEST_DIR/$SRC"
	mkdir -p "$DEST"
	echo "$DATE :: Backing up $SRC to $DEST."  >> "$LOG_FILE"
	rsync -avz --exclude='/dev/pts' --exclude='/dev/shm' --exclude='/data/back*' "/$SRC/" "$DEST/" --progress >> "$LOG_FILE" 2>&1
	echo "$DATE :: Backup completed for $SRC."  >> "$LOG_FILE"
done
