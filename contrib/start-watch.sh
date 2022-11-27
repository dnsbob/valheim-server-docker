#!/bin/bash
# start-watch.sh

log=/tmp/watchvalheimlog.log
echo "`date` $0 started" >> $log

export BACKUP_BUCKET=dnsbob-valheim
export BACKUP_PATH=backup
export WORLD_NAME=dnsbob20220218
export WORLD_PATH=/root/valheim-server/config/worlds_local
export HANOI_BASE=/root/valheim-server/hanoi
export BACKUP_SCRIPT=/home/ec2-user/valheim-server-docker/contrib/valheim-backup-hanoi-aws.sh
export WATCH_SAVE_HOOK="$BACKUP_SCRIPT $WORLD_NAME $WORLD_PATH 6 $HANOI_BASE $BACKUP_BUCKET $BACKUP_PATH"
/home/ec2-user/valheim-server-docker/contrib/watchvalheimlog.py /root/valheim-server/log/supervisor/valheim-server-stdout---supervisor-*.log 2>&1 >> $log
