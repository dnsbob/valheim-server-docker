#!/bin/bash
# aws_s3_backup.sh

# Example POST_BACKUP_HOOK script.
# Use by running container with
#  -e POST_BACKUP_HOOK="/usr/local/share/valheim/contrib/aws_s3_backup.sh @BACKUP_FILE@"
#  -e BACKUP_BUCKET="my_s3_bucket"
#  -e BACKUP_PATH="my_path"
#
# Mandatory variables:
# BACKUP_BUCKET = AWS S3 bucket name
# BACKUP_PATH = remote path where the zip file will be stored
#               (without the "s3://" prefix)
#
# Optional variables: none

# Full path to the worlds_local backup ZIP we just created
# e.g. /config/backups/worlds_local-20210303-144536.zip
backup_file=$1

: "${BACKUP_BUCKET:=}" "${BACKUP_PATH:=}"

if [ -z "$BACKUP_BUCKET" ] || [ -z "$BACKUP_PATH" ]; then
    echo "One of BACKUP_BUCKET or BACKUP_PATH not set - quitting"
    exit 1
fi

# remove trailing slash if any
BACKUP_PATH=${BACKUP_PATH%/}

destination="s3://$BACKUP_BUCKET/$BACKUP_PATH/$(basename "$backup_file")"

echo "Using aws s3 cp to copy $backup_file to $destination"
#timeout 300 aws s3 cp "$backup_file" "$destination"
aws s3 cp "$backup_file" "$destination"
