#!/bin/bash

#export LOGTO="FILE"
#export NOEXITONERROR="TRUE"
#. /usr/local/scripts/public/stdlib.sh

# ./video_integrity_check.sh X Y
#
# A script to check for corrupt video files using ffmpeg
#

function helpme
{
  echo "This script should have two arguments like so ./video_integrity_check.sh X Y"
  echo "X is the directory to scan"
  echo "Y is the directory to push bad files"
  exit
}

FROM_DIRECTORY=$1
GOTO_DIRECTORY=$2

if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters"
    helpme
fi

if [[ ! -d "$FROM_DIRECTORY" ]]
then
    echo "From directory supplied do not exist"
    helpme
fi

if [[ ! -d "$GOTO_DIRECTORY" ]]
then
    echo "To directory supplied do not exist"
    helpme
fi

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

echo Finding files in $FROM_DIRECTORY to move out...

/usr/bin/find $FROM_DIRECTORY -type f -name "*.mp4" -print0 | while read -d $'\0' FILENAM
do
  echo
  echo Checking $FILENAM
  if [[ -e "$FILENAM.ffmpeg_checked" ]]
  then 
    echo already ffmepg_checked!  
  else
    echo ffmpeging
    echo /usr/bin/ffmpeg -i $FILENAM -v error -f null - 2\>"$FILENAM.ffmpeg_checked.working"
    #/usr/bin/ffmpeg -i "$FILENAM" -v error -f null - 2>"$FILENAM.ffmpeg_checked.working"
    echo output $?
    ERRCOUNT=`grep -i error "$FILENAM.ffmpeg_checked.working" |wc -l`
    
    if [ $ERRCOUNT -gt 0 ]
    then
      echo "found $ERRCOUNT errors with $FILENAM moving"
      #
      # Find where we are going to copy to and check for a duplicate file 
      #
      ARCHSTR="/base/"
      if [[ -e "$GOTO_DIRECTORY$ARCHSTR$FILENAM" ]]
      then
        ARCHSTR="/dupe-`date +%Y%m%d`/"
        if [[ -e "$GOTO_DIRECTORY$ARCHSTR$FILENAM" ]]
        then
          ARCHSTR="/dupe-`date +%Y%m%d%H%M`/"
          if [[ -e "$GOTO_DIRECTORY$ARCHSTR$FILENAM" ]]
          then
            #ignore the file
            echo Hit a duplicate for this file $FILENAM
            continue
          fi
        fi
      fi
      
      # Make sure our new directory exists
      #
      NEWDIR=$GOTO_DIRECTORY$ARCHSTR`dirname "$FILENAM"` 
      if [[ ! -d $NEWDIR ]]
      then
        mkdir -p $NEWDIR
      fi
      
      #
      # Move out the file
      # 
      echo Moving $FILENAM $NEWDIR/`basename $FILENAM`
      mv $FILENAM $NEWDIR/`basename $FILENAM` 
      mv $FILENAM.ffmpeg_checked.working $NEWDIR/`basename $FILENAM`.ffmpeg_checked
	  else
	    echo file fine  
	    mv "$FILENAM.ffmpeg_checked.working" "$FILENAM.ffmpeg_checked"
    fi
  fi
done