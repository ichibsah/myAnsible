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

#########################################
### LOOPBACK – ALWAYS ALLOWED
#########################################
iptables -A INPUT -i lo -j ACCEPT

#########################################
### BASIC PACKET SANITY
#########################################
iptables -A INPUT -m conntrack --ctstate INVALID -j LOG --log-prefix "INVALID_PKT: "
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

iptables -A INPUT -p tcp ! --syn -m conntrack --ctstate NEW \
         -j LOG --log-prefix "BAD_TCP_FLAG: "
iptables -A INPUT -p tcp ! --syn -m conntrack --ctstate NEW -j DROP

#########################################
### ANTI-SPOOFING (LOG + DROP)
#########################################
iptables -A INPUT -i $WAN -s $LAN_NET -m limit --limit 3/m \
         -j LOG --log-prefix "SPOOF_LAN_ON_WAN: "
iptables -A INPUT -i $WAN -s $LAN_NET -j DROP

iptables -A INPUT -i $WAN -s $MAN_NET -m limit --limit 3/m \
         -j LOG --log-prefix "SPOOF_MAN_ON_WAN: "
iptables -A INPUT -i $WAN -s $MAN_NET -j DROP

iptables -A INPUT -i $WAN -s $WLAN_NET -m limit --limit 3/m \
         -j LOG --log-prefix "SPOOF_WLAN_ON_WAN: "
iptables -A INPUT -i $WAN -s $WLAN_NET -j DROP

# Verify internal networks match their interfaces
iptables -A INPUT -i $LAN ! -s $LAN_NET \
         -m limit --limit 3/m -j LOG --log-prefix "SPOOF_FAIL_LAN: "
iptables -A INPUT -i $LAN ! -s $LAN_NET -j DROP

iptables -A INPUT -i $MAN ! -s $MAN_NET \
         -m limit --limit 3/m -j LOG --log-prefix "SPOOF_FAIL_MAN: "
iptables -A INPUT -i $MAN ! -s $MAN_NET -j DROP

iptables -A INPUT -i $WLAN ! -s $WLAN_NET \
         -m limit --limit 3/m -j LOG --log-prefix "SPOOF_FAIL_WLAN: "
iptables -A INPUT -i $WLAN ! -s $WLAN_NET -j DROP

#########################################
### ICMP – SAFE TYPES
#########################################
iptables -A INPUT -p icmp --icmp-type echo-request \
         -m limit --limit 1/s \
         -j LOG --log-prefix "ICMP_PING: "
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

#########################################
### ZONE FIREWALLING (Cisco ASA style)
#########################################

### LAN → ANY (ACCEPTED)
iptables -A FORWARD -i $LAN -j ACCEPT

### MAN → WAN ALLOWED
iptables -A FORWARD -i $MAN -o $WAN -j ACCEPT

### MAN → LAN BLOCKED (LOG + DROP)
iptables -A FORWARD -i $MAN -o $LAN -m limit --limit 5/m \
         -j LOG --log-prefix "MAN_BLOCK_LAN: "
iptables -A FORWARD -i $MAN -o $LAN -j DROP

### WLAN → WAN ALLOWED
iptables -A FORWARD -i $WLAN -o $WAN -j ACCEPT

### WLAN → MAN BLOCKED
iptables -A FORWARD -i $WLAN -o $MAN -m limit --limit 5/m \
         -j LOG --log-prefix "WLAN_BLOCK_MAN: "
iptables -A FORWARD -i $WLAN -o $MAN -j DROP

### WLAN → LAN BLOCKED
iptables -A FORWARD -i $WLAN -o $LAN -m limit --limit 5/m \
         -j LOG --log-prefix "WLAN_BLOCK_LAN: "
iptables -A FORWARD -i $WLAN -o $LAN -j DROP

### VPN → LAN allowed (log)
iptables -A INPUT -p esp -m limit --limit 1/m \
         -j LOG --log-prefix "VPN_TRAFFIC: "
iptables -A INPUT -p esp -j ACCEPT

#########################################
### BOILERPLATE NAT
#########################################
iptables -t nat -A POSTROUTING -o $WAN -j MASQUERADE

#########################################
### FINAL CATCH-ALL LOGGING
#########################################
iptables -A INPUT -m limit --limit 2/m -j LOG --log-prefix "DROP_INPUT: "
iptables -A FORWARD -m limit --limit 2/m -j LOG --log-prefix "DROP_FORWARD: "

### SAVE
iptables-save > /etc/iptables/rules.v4