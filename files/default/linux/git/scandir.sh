#!/bin/bash
SUB="gitea"
ls -1|grep -v run.sh|while read line 
do 
  cd $line 
  TRYME=`git remote show origin |grep Push`
  echo `pwd` - $TRYME
  if [[ "$line" == *"$SUB"* ]]; then
    echo Moving
    echo ~/git/puppet/puppet-scriptspublic/files/default/linux/git/move-to-github.sh 
  fi
  cd .. 
done