#!/bin/bash

#
#
# Script accepts two inputs, the first is the interval you want, the second is a random offset
# supplied preferably by fqdn_rand, it then spits out a list of evenly spaced intervals to run
#
# - Simon
#

INTERVAL=$1
NUMBER=$(( 60 / $INTERVAL ))
RANDON=$2

COUNTER=0

CRONSTR=""
TALLY=$RANDON

while [ $COUNTER -lt $NUMBER ]
do
        CRONNUM=$(( $RANDON + ( $COUNTER * $INTERVAL )))

        if [ $COUNTER -lt 1 ]
        then
                CRONSTR="$CRONSTR$CRONNUM"
        else
                CRONSTR="$CRONSTR,$CRONNUM"
        fi
  let COUNTER+=1
done

echo -e $CRONSTR