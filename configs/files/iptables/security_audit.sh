#!/bin/bash

# --- Default Policies ---
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# --- Flush Rules ---
iptables -F
iptables -t nat -F

# --- Allow Loopback ---
iptables -A INPUT -i lo -j ACCEPT

# --- Block Invalid ---
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

# --- Allow Established ---
iptables -A INPUT  -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# --- ICMP (Safe subset) ---
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT

# --- Zone Rules Example ---
# LAN ↔ WAN (allow outbound)
iptables -A FORWARD -i $LAN -o $WAN -j ACCEPT

# MAN isolated from LAN
iptables -A FORWARD -i $MAN -o $LAN -j DROP

# WLAN restricted
iptables -A FORWARD -i $WLAN -o $LAN -j DROP

# --- NAT ---
iptables -t nat -A POSTROUTING -o $WAN -j MASQUERADE