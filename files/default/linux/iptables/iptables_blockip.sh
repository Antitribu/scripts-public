#!/bin/bash
/sbin/iptables -I INPUT -s $1 -j DROP
