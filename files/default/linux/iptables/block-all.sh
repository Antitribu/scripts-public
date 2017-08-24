#!/bin/bash
IPT="/sbin/iptables"

$IPT --flush
$IPT -F
$IPT -X
$IPT -t nat -F
$IPT -t nat -X

$IPT -A INPUT -i lo -j ACCEPT
$IPT -A OUTPUT -o lo -j ACCEPT

#Accept
$IPT -A INPUT -p icmp -j ACCEPT
$IPT -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

#Drop
$IPT -A INPUT -j DROP
