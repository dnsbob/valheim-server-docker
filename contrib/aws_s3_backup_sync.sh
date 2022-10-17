#!/bin/bash
# aws_s3_backup_sync.sh

# Example POST_BACKUP_HOOK script.
# Use by running container with
#  -e POST_BACKUP_HOOK="/usr/local/share/valheim/contrib/aws_s3_backup_sync.sh @BACKUP_DIR@"
#  -e BACKUP_BUCKET="my_s3_bucket"
#  -e BACKUP_PATH="my_path"
#
# Mandatory variables:
# BACKUP_BUCKET = AWS S3 bucket name
# BACKUP_PATH = remote path where the backup dir will be stored
#               (without the "s3://" prefix)
#
# Optional variables: none

# Full path to the backup dir
# e.g. /config/backups/
backup_dir=$1

: "${BACKUP_BUCKET:=}" "${BACKUP_PATH:=}"

if [ -z "$BACKUP_BUCKET" ] || [ -z "$BACKUP_PATH" ]; then
    echo "One of BACKUP_BUCKET or BACKUP_PATH not set - quitting"
    exit 1
fi

# remove trailing slash if any
BACKUP_PATH=${BACKUP_PATH%/}

destination="s3://$BACKUP_BUCKET/$BACKUP_PATH/$(basename "$backup_dir")"

echo "Using aws s3 sync to sync $backup_dir to $destination"
aws s3 sync --delete "$backup_dir" "$destination"
