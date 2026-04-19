#!/bin/bash
#--------------------------------------
#
ip2inet() {
    local input=$1

    if echo "$input" | grep -E "^([0-9]{1,3}\.){3}[0-9]{1,3}$" >/dev/null; then
        # If input is an IP address, retrieve the interface name
        name=$(ip -o addr show | grep "$input" | awk '{print $2}')
        echo "$name"
    elif (ip -o link show | grep -w "$input") &> /dev/null; then
        # If input is an interface name, retrieve the IP address
        ip=$(ip -o addr show "$input" | awk '{print $4}' | cut -d/ -f1)
        echo "$ip"
    else
        # If input is neither an IP address nor an interface name, print an error message
        echo "Invalid input"
        return 1
    fi
}

#interface variables
#/sbin/ifconfig -a
VPN=esp
LOOP=lo
LAN_IP=10.1.0.254
WLAN_IP=192.168.77.254
WAN_IP=192.168.0.80
LOOP_IP=127.0.0.1
MAN_IP=192.168.8.254
LAN=$(ip2inet $LAN_IP)      # eno1
MAN=$(ip2inet $MAN_IP)      # Mereyem
WAN=$(ip2inet $WAN_IP)      # Vodafone
WLAN=$(ip2inet $WLAN_IP)    # ASUS enp1s0
echo $LAN
echo $MAN
echo $WAN
echo $WLAN
#