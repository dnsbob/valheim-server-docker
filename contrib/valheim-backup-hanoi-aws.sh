#!/bin/bash
# valheim-backup-hanoi-aws.sh  WORLD_NAME  WORLD_PATH  max basedir  BACKUP_BUCKET  BACKUP_PATH

if [ $# -ne 6 ]; then
  echo “usage:  $0 WORLD_NAME  WORLD_PATH  max basedir  BACKUP_BUCKET  BACKUP_PATH”
  exit 1
fi

WORLD_NAME=$1
WORLD_PATH=$2
max=$3
basedir=$4
BACKUP_BUCKET=$5
BACKUP_PATH=$6

zipfile=`bin/valheim-save-zip.sh echo $WORLD_NAME $WORLD_PATH`
bin/hanoi-backup.sh $max $basedir $zipfile
bin/aws_s3_backup_sync.sh $basedir $BACKUP_BUCKET $BACKUP_PATH
