#!/bin/bash

#export LOGTO="FILE"
export NOEXITONERROR="TRUE"
. /usr/local/scripts/public/stdlib.sh

# ./video_integrity_check.sh X Y
#
# A script to check for corrupt video files using ffmpeg
#

function helpme
{
  echo "This script should have two arguments like so ./video_integrity_check.sh X Y"
  echo "X is the directory to scan"
  echo "Y is the directory to push bad files"
  exit 64
}

FROM_DIRECTORY=$1
GOTO_DIRECTORY=$2
RETVAL=0

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
    mkdir -p "$GOTO_DIRECTORY"
fi

echo $0

# rely on jenkins to enforce concurrency
#r=$(pidof -x -o $$ $0)
#set -- $r
#if [ "${#@}" -eq 1 ];then
# echo "Running"
#else
# echo "Already Running"
# exit 0
#fi

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

echo Finding files in $FROM_DIRECTORY to move out...

/usr/bin/find $FROM_DIRECTORY -type f \( -name "*.m4v" -o -name "*.mp4" -o -name "*.avi" \) -print0 | while read -d $'\0' FILENAM
do
  if [[ -e "$FILENAM.ffmpeg_checked" ]]
  then 
    FOO=1
    #echo already ffmepg_checked!
  else
    echo
    echo
    echo ------------------------------------
    echo Checking $FILENAM ....
    echo
    echo /usr/bin/ffmpeg -i \"$FILENAM\" -v error -f null - 2\>\"$FILENAM.ffmpeg_checked.working\"
    echo

    touch "$FILENAM.ffmpeg_checked.working"
    if [ $? -ne 0 ]
    then 
      exit 32
    fi
    
    time /usr/bin/ffmpeg -nostdin -i "$FILENAM" -v error -f null - 2>"$FILENAM.ffmpeg_checked.working"
    echo output $?
    ERRCOUNT=`grep -i error "$FILENAM.ffmpeg_checked.working" |wc -l`
    
    if [ $ERRCOUNT -gt 0 ]
    then
      RETVAL=127
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
exit $RETVAL