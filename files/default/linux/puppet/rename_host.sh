#!/bin/bash
echo $1 > /etc/hostname
rm -rf /var/lib/puppet/ssl/*
shutdown -r now