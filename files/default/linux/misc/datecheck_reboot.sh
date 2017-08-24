#!/bin/bash
. /usr/local/scripts/public/stdlib.sh

function helpme
{
  echo "This script should have two arguments like so $0 X Y"
  echo "X lower bound for day of the month"
  echo "Y upper bound for day of the month"
  exit
}

case "$#" in
0)  /sbin/shutdown -r 2
    ;;
2)  if [ $(date +\%d) -ge $1 -a $(date +\%d) -le $2 ]
    then
      /sbin/shutdown -r 2
    fi
    ;;
*)  helpme
    ;;
esac
