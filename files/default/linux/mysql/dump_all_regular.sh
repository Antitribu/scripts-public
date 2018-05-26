#!/bin/bash
. /usr/local/scripts/public/stdlib.sh

HOSTN=$1
USERN=$2
PASSW=$3
DIREC=$4

mkdir -p $DIREC/day
mkdir -p $DIREC/week
mkdir -p $DIREC/month

/usr/bin/mysqldump -h $HOSTN -u $USERN -p$PASSW --all-databases > $DIREC/day/mysql_dump.sql

if [ `date '+%u'` -eq 0 ]
then
  echo "Starting Week Backup at " `date`

  /usr/bin/rsync $DIREC/day/ $DIREC/week/ -avz --delete-delay
  echo "Stoping Month Backup at " `date`

fi

if [ `date '+%d'` -eq 1 ]
then
  echo "Starting Month Backup at " `date`
  /usr/bin/rsync $DIREC/day/ $DIREC/month/ -avz --delete-delay
  echo "Stoping Month Backup at " `date`
fi