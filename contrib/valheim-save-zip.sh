#!/bin/bash
# valheim-backup-cron.sh

usage () {
  echo "usage:  $0  backupscript"
  echo "        and env vars WORLD_NAME and WORLD_PATH must be set"
  exit 1
}

if [ "X" = "X$2" -o "X" = "X$WORLD_NAME" -o "X" = "X$WORLD_PATH" ]; then
  usage
fi

worldpath="$WORLD_PATH"
worldname="$WORLD_NAME"
backupscript="$1"

tmpdir=/tmp/valheim-backup-cron
mydir=`pwd`

currenttime=`date '+%b %d %H:%M'`

# does tmp dir exist
if [ ! -d $tmpdir ]; then
  mkdir -p $tmpdir
fi

cd "${worldpath}"
zip $tmpdir/backup.zip "${worldname}.db" "${worldname}.fwl"
cd "${mydir}"
$backupscript $tmpdir/backup.zip || echo "failed to backup" && exit 1
echo "$currenttime" > $tmpdir/backuptime
