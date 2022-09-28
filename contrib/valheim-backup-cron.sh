#!/bin/bash
# valheim-backup-cron.sh

if [ "X" = "X$3" ]; then
  echo "usage:  $0  worlds-path backupscript"
  exit 1
fi

# run once a minute in cron
# list latest save file
# if already saved, exit
# if flag is not set, and current time does not match the file time, set the flag and save the file time
# if flag was already set and the time matches the previous time,
#     then the file has not changed for over a minute, so the save should be complete
#     backup this save-file, clear the flag

worldpath="$1"
worldname="$WORLD_NAME"
backupscript="$2"

tmpdir=/tmp/valheim-backup-cron
mydir=`pwd`

currenttime=`date '+%b %d %H:%M'`

# does tmp dir exist
if [ ! -d $tmpdir ]; then
  mkdir -p $tmpdir
fi

# get last backup time
if [ -f $tmpdir/backuptime ]; then
  backuptime=`cat $tmpdir/backuptime`
else
  backuptime=none
  echo none > $tmpdir/backuptime
fi

# latst file time
latestfileline=`ls -ltr "${1}/${2}.db" 2>/dev/null | tail -1`
if [ "X" = "X$latestfileline" ]; then
  filetime=none
else
  filetime=`awk '{print $6,$7,$8}' <<< $latestfileline`
fi

# compare current file time to last backup time
if [ "$filetime" = "$backuptime" ]; then
  exit
fi

# previous run file time
if [ -f $tmpdir/oldfiletime ]; then
  oldfiletime=`cat $tmpdir/oldfiletime`
else
  # first run - save file time
  echo $filetime > $tmpdir/oldfiletime
  exit
fi

# is file newer than oldfiletime
if [ "$oldfiletime" != "$filetime" ]; then
  # file change since last time
  # save new file time
  echo $filetime > $tmpdir/oldfiletime
  exit
fi
#else there is a new save file

# compare current time to file time
if [ "$currenttime" = "$filetime" ]; then
  # file was just written
  exit
fi
#else
# check backup flag
if [ ! -f $tmpdir/backupflag ]; then
  touch $tmpdir/backupflag
  exit
fi
#else
# flag was set, so file has been stable for a minute or two
# save the file as a new backup
##savefile=`awk '{print $9}' <<< $latestfileline`
cd "${worldpath}"
zip $tmpdir/backup.zip "${2}.db" "${2}.fwl"
cd "${mydir}"
$backupscript $tmpdir/backup.zip || echo "failed to backup" && exit 1
rm $tmpdir/backupflag $tmpdir/oldfiletime
echo "$filetime" > $tmpdir/backuptime
