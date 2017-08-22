#!/bin/bash
export NOEXITONERROR="TRUE"
. /usr/local/scripts/public/stdlib.sh

BLUMAC=$1
NEARBY=`/usr/bin/hcitool cc $BLUMAC && /usr/bin/hcitool auth $BLUMAC && /usr/bin/hcitool dc $BLUMAC; echo $?`

SCRSAV=`sudo -u pi ps aux |grep "xscreensaver" |grep -v grep |awk '{print $2}'`

if [ $NEARBY -eq 0 ]
then
  echo Phone is near
  if [ ! -z "$SCRSAV" ]
  then
    echo killing screensaver
    sudo -u pi kill $SCRSAV
  else 
    echo Already unlocked 
  fi
else
  echo Phone is away
  if [ -z "$SCRSAV" ]
  then
    echo starting screensaver
    sudo -u pi xscreensaver &
    sleep 1
    sudo -u pi xscreensaver-command -lock
  else
    echo Still locked...
  fi
fi