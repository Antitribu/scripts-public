#!/bin/bash

# Terrible idea to run this, still vaguely saner than shutdown -r now

WALL="/usr/bin/wall"
VIRSH="/usr/sbin/virsh"
DOCKER="/usr/bin/docker"

echo "Shutting down VMs" | $WALL

$VIRSH list | grep running | awk '{print $2}' | while read VMrunning; do
	echo Stopping $VMrunning
	$VIRSH shutdown $VMrunning
done

echo "Shutting down Docker" | $WALL

$DOCKER ps | grep Up | awk '{print $1}' | while read Dockerrunning; do
	echo Stopping $Dockerrunning
	$DOCKER stop $Dockerrunning
done

sleep 30

echo "Destroying stuck VMs" | $WALL

$VIRSH list | grep running | awk '{print $2}' | while read VMrunning; do
	echo Destroying $VMrunning
	$VIRSH destroy $VMrunning
done

echo "Stopping SAMBA" | $WALL

/usr/local/sbin/samba stop

echo "Umounting raid devices" | $WALL

ls -1 /dev/md* | while read MDpart; do
	umount $MDpart
done

/usr/local/sbin/mdcmd stop

