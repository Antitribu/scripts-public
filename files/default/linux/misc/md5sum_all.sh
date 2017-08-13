#!/bin/bash
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
find $1 -type f -not -name "*.md5sum-`hostname`" | while read line
do
  if [ ! -e $line.md5sum-`hostname` ]
  then
    md5sum $line > $line.md5sum-`hostname`
    cat $line.md5sum-`hostname`
  fi
done