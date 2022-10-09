#!/bin/bash
# hanoi-backup.sh max basedir file
# backups in "Tower of Hanoi" sequence
# https://en.wikipedia.org/wiki/Backup_rotation_scheme#Tower_of_Hanoi
# I called it a graycode sequence when I figured it out sometime before 1993,
# only to later hear that others had also found it and called it Tower of Hanoi.
# every second backup in slot 1
# every fourth backup in slot 2
# every eighth backup in slot 3
# etc
# so that at all times there are the last two backups, 
# one of the two before that, 
# one of the four before that, 
# one of the eight before that, etc

# this is the logical extension of hourly/daily/weekly/monthly/yearly backups
# but is based on the sequence of backups, not time
# this is especially good for game backups, 
# where backups only happen when the game is played,
# and not based on the calendar

usage () {
  echo "usage:  $0  max  basedir  file"
  exit 1
}

# from https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash
isnum_Case() { case ${1#[-+]} in ''|.|*[!0-9.]*|*.*.*) return 1;; esac ;}

# max can be 1 to 9
max=$1
if ! isnum_Case $max; then
  usage
fi
if [ 1 -gt $max ]; then
  usage
fi
if [ 9 -lt $max ]; then
  usage
fi

basedir=$2
mkdir -p $basedir
if [ ! -d "$basedir" ]; then
  usage
fi

file=$3
if [ ! -f "$file" ]; then
  usage
fi

flag=flag
dir=backup

for i in 1 2 3 4 5 6 7 8 9
do
  if [ $i -eq $max ]; then
    break
  fi
  if [ -f $basedir/$flag$i ]; then
    rm $basedir/$flag$i
    break
  fi
  touch $basedir/$flag$i
done

echo "backup $i"
mkdir -p $basedir/$dir$i
cp -p $file $basedir/$dir$i/
