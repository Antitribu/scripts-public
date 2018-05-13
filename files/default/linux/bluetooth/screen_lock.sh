#!/bin/bash
export NOEXITONERROR="TRUE"
export LOGTO="FILE"
. /usr/local/scripts/public/stdlib.sh

BLUMAC=$1
NEARBY=`/usr/bin/hcitool cc $BLUMAC && /usr/bin/hcitool auth $BLUMAC && /usr/bin/hcitool dc $BLUMAC; echo $?`

SCRSAV=`sudo -u pi ps aux |grep "xscreensaver" |grep -v grep |awk '{print $2}'`

if [ $NEARBY -eq 0 ]
then
  if [ ! -z "$SCRSAV" ]
  then
    echo Phone is near
    echo killing screensaver
    sudo -u pi kill $SCRSAV
  fi
else
  if [ -z "$SCRSAV" ]
  then
    echo Phone is away
    echo starting screensaver
    sudo -u pi xscreensaver &
    sleep 1
    sudo -u pi xscreensaver-command -lock
  fi
fi
