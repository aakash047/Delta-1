#!/bin/bash

USER="db_user"
PASSWORD="db_pass"
DATABASE="server_db"

BACKUP_DIR="/home/aakash/Desktop/Delta/backups"
mkdir -p "$BACKUP_DIR"

TIMESTAMP=$(date +"%F_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/$DATABASE-$TIMESTAMP.sql"

mysqldump -u "$USER" -p"$PASSWORD" "$DATABASE" > "$BACKUP_FILE"
echo "Backup completed: $BACKUP_FILE" >> "$BACKUP_DIR/backup.log"


# crontab -e
# 3 5-8,15 1 1-7 1 ./backup.sh >/dev/null 2>&1
