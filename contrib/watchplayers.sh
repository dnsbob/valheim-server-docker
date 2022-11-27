#!/bin/bash
# watchplayers.sh
# poweroff if no players for X minutes

m=5 # minutes to poweroff
count=0
while [ 1 -eq 1 ]
  do
  p=`python3 -c 'import a2s;print(len(a2s.players(("127.0.0.1",2457))))'`
  if [ "$p" -eq 0 ]; then
    count=$(( $count + 1 ))
    if [ $count -ge $m ]; then
      echo "$@ - poweroff at count $count" >> /root/watchplayers.log
      sleep 2
      poweroff
    fi
  else
    count=0
  fi
  echo $count
  sleep 60
done
