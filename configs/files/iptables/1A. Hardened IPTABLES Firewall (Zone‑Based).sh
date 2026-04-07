#!/bin/bash

### --- VARIABLES ---
WAN="enp3s0"
LAN="eno1"
MAN="enp2s0f1"
WLAN="enp1s0"
VPN="esp"

WAN_NET="192.168.0.0/24"
LAN_NET="10.1.0.0/24"
MAN_NET="192.168.8.0/24"
WLAN_NET="192.168.77.0/24"

### --- DEFAULT POLICIES ---
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP

iptables -F
iptables -t nat -F

### --- LOOPBACK ---
iptables -A INPUT -i lo -j ACCEPT

### --- BASIC PROTECTION ---
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp ! --syn -m conntrack --ctstate NEW -j DROP

### --- ANTI-SPOOFING ---
iptables -A INPUT -i $WAN -s $LAN_NET -j DROP
iptables -A INPUT -i $WAN -s $MAN_NET -j DROP
iptables -A INPUT -i $WAN -s $WLAN_NET -j DROP

iptables -A INPUT -i $LAN ! -s $LAN_NET -j DROP
iptables -A INPUT -i $MAN ! -s $MAN_NET -j DROP
iptables -A INPUT -i $WLAN ! -s $WLAN_NET -j DROP

### --- ICMP SAFE RULES ---
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT

### --- ZONE RULES ---

# LAN → ANY (allowed)
iptables -A FORWARD -i $LAN -j ACCEPT

# MAN → Internet only, blocked from LAN
iptables -A FORWARD -i $MAN -o $WAN -j ACCEPT
iptables -A FORWARD -i $MAN -o $LAN -j DROP

# WLAN → Internet only
iptables -A FORWARD -i $WLAN -o $WAN -j ACCEPT
iptables -A FORWARD -i $WLAN -o $LAN -j DROP
iptables -A FORWARD -i $WLAN -o $MAN -j DROP

# VPN → LAN allowed (adjust as you prefer)
iptables -A INPUT -p esp -j ACCEPT

### --- NAT ---
iptables -t nat -A POSTROUTING -o $WAN -j MASQUERADE

### --- LOGGING ---
iptables -A INPUT -m limit --limit 2/min -j LOG --log-prefix "IPT_INPUT_DROP: "
iptables -A FORWARD -m limit --limit 2/min -j LOG --log-prefix "IPT_FW_DROP: "

### --- SAVE RULES ---
iptables-save > /etc/iptables/rules.v4