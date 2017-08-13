#!/bin/bash
# This script limits the queries per second to 5/s
# with a burst rate of 15/s and does not require
# buffer space changes

# Requests per second
RQS="15"

# Requests per 7 seconds
RQH="60"

iptables --flush
iptables -A INPUT -p udp --dport 53 -m hashlimit --hashlimit-name DNSDUMP --hashlimit 30/minute --hashlimit-burst 60 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j DROP
