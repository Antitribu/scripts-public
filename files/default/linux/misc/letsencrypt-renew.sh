#!/bin/bash
export NOEXITONERROR="TRUE"
. /usr/local/scripts/linux/stdlib.sh

CERTS_DIR="/etc/letsencrypt/live/"
FULL_CHAIN_LIVE_PEMS_DIR="/etc/letsencrypt/fullpem/"
FULL_CHAIN_TMP_PEMS_DIR="/tmp/tmp_pems/"
LIVE_PEM=""
TMP_PEM=""
UPDATE_LIVE_PEMS="0"

TIMESTAMP=$(date +"%Y%m%d%H%M")

mkdir -p "$FULL_CHAIN_LIVE_PEMS_DIR"

# Renew all Let's Encrypt certificates
/usr/bin/certbot renew
CRETVAL=$?
if [ $? -eq 0 ] ; then
  mkdir -p "$FULL_CHAIN_TMP_PEMS_DIR"
  cd $CERTS_DIR
  for CERT_NAME in $(ls -d */); do
    # Concatenate renewed certificate pems into one pem
    cat $CERTS_DIR$CERT_NAME* > $FULL_CHAIN_TMP_PEMS_DIR${CERT_NAME%%/}.pem
    LIVE_PEM=$FULL_CHAIN_LIVE_PEMS_DIR${CERT_NAME%%/}.pem
    TMP_PEM=$FULL_CHAIN_TMP_PEMS_DIR${CERT_NAME%%/}.pem
    # If the file doesn't exist or the md5sum between the files is different
    if [ ! -f $LIVE_PEM ] || [ `md5sum $LIVE_PEM |cut -f 1 -d " "` != `md5sum $TMP_PEM |cut -f 1 -d " "` ]; then
        echo $LIVE_PEM "has been changed."
        UPDATE_LIVE_PEMS="1"
    fi
  done
  if [ $UPDATE_LIVE_PEMS -ne 0 ] ; then
    echo "Updating live pems....."
    # Take a copy of live certs
    BACKUP_DIR="/backup/$TIMESTAMP"
    mkdir -p "$BACKUP_DIR"
    mv $FULL_CHAIN_LIVE_PEMS_DIR* $BACKUP_DIR
    mv $FULL_CHAIN_TMP_PEMS_DIR* $FULL_CHAIN_LIVE_PEMS_DIR
  else
    echo "Live pems don't need updating...."
  fi
  rm -rf "$FULL_CHAIN_TMP_PEMS_DIR"
else
  echo "Renewal was unsuccessful"
  RETVAL=$CRETVAL
fi

exit $RETVAL
