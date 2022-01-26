#!/bin/bash
set -x

# This is a script to move a Git repo into Github and 
# swap the origin to github. It uses the local directory
# name as the name for the repo.
#
# It's fragile and depends on the github cli client

WORKD=`pwd`
REPONAME=`basename $WORKD`
gh repo create $REPONAME --private --push --source=. --remote=githuborigin --disable-wiki --disable-issues
git remote rm origin
sed -i 's/githuborigin/origin/g' .git/config
