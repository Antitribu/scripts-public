#!/bin/bash
. /usr/local/scripts/public/stdlib.sh

HOSTN=$1
USERN=$2
PASSW=$3
DIREC=$4

MYSQL=/usr/bin/mysql
MYSQLDUMP=/usr/bin/mysqldump

mkdir -p $DIREC/day
mkdir -p $DIREC/week
mkdir -p $DIREC/month

databases=`$MYSQL --user=$USERN -p$PASSW -h $HOSTN -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema)"`

for db in $databases; do
  $MYSQLDUMP --force --opt --user=$USERN -p$PASSW -h $HOSTN --databases $db | gzip > "$DIREC/day/$db.gz"
done

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