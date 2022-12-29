#!/bin/bash
# valheim-backup-hanoi-aws.sh  WORLD_NAME  WORLD_PATH  max basedir  BACKUP_BUCKET  BACKUP_PATH

if [ $# -ne 6 ]; then
  echo “usage:  $0 WORLD_NAME  WORLD_PATH  max basedir  BACKUP_BUCKET  BACKUP_PATH”
  exit 1
fi

WORLD_NAME=${1:-NONE}
WORLD_PATH=${2:-NONE}
max=${3:-NONE}
basedir=${4:-NONE}
BACKUP_BUCKET=${5:-NONE}
BACKUP_PATH=${6:-NONE}

echo "world=${WORLD_PATH}/${WORLD_NAME} max=$max basedir=$basedir bucket=${BACKUP_BUCKET} path=$BACKUP_PATH" >> /tmp/${0##*/}.log

zipfile=`bin/valheim-save-zip.sh echo $WORLD_NAME $WORLD_PATH | tail -1`
bin/hanoi-backup.sh $max $basedir $zipfile
bin/aws_s3_backup_sync.sh $basedir $BACKUP_BUCKET $BACKUP_PATH
