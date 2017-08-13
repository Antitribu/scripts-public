#!/bin/bash
YourIP=67.18.176.122
YourPort=443
TargetIP=10.13.3.10
TargetPort=443

iptables -t nat -A PREROUTING --dst $YourIP -p tcp --dport $YourPort -j DNAT --to-destination $TargetIP:$TargetPort
iptables -t nat -A POSTROUTING -p tcp --dst $TargetIP --dport $TargetPort -j SNAT --to-source $YourIP
iptables -t nat -A OUTPUT --dst $YourIP -p tcp --dport $YourPort -j DNAT --to-destination $TargetIP:$TargetPort

