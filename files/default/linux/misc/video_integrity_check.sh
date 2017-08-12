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
		/usr/bin/ffmpeg -i $FILENAM -v error -f null - 2>"$FILENAM.ffmpeg_checked.working"
	fi
done