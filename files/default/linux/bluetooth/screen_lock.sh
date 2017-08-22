#!/bin/bash
export NOEXITONERROR="TRUE"
. /usr/local/scripts/public/stdlib.sh

BLUMAC=$1
NEARBY=`hcitool cc $BLUMAC && hcitool auth $BLUMAC && hcitool dc $BLUMAC; echo $?`

if [ $NEARBY -eq 0 ]
then
  echo Phone is near
  sudo -u pi kill `ps aux |grep "xscreensaver" |grep -v grep |awk '{print $2}'`
else
  echo Phone is away
  sudo -u pi xscreensaver &
  sleep 1
  sudo -u pi xscreensaver-command -lock
fi