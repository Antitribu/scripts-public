#!/bin/bash
export NOEXITONERROR="TRUE"
. /usr/local/scripts/public/stdlib.sh

BLUMAC=$1
NEARBY=`hcitool cc $BLUMAC && hcitool auth $BLUMAC && hcitool dc $BLUMAC; echo $?`

SCRSAV=`sudo -u pi ps aux |grep "xscreensaver" |grep -v grep |awk '{print $2}'`

if [ $NEARBY -eq 0 ]
then
  echo Phone is near
  if [ -z "$SCRSAV" ]
  then
    echo killing screensaver
    sudo -u pi kill $SCRSAV
  fi
else
  echo Phone is away
  echo $SCRSAV
  echo ====
  if [ ! -z "$SCRSAV" ]
  then
    echo starting screensaver
    sudo -u pi xscreensaver &
    sleep 1
    sudo -u pi xscreensaver-command -lock
  fi
fi