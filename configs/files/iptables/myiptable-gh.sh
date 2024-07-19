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
LAN_IP=10.3.0.254
WLAN_IP=192.168.77.254
WAN_IP=192.168.1.80
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
#interface variables
#/sbin/ifconfig -a
#LAN=eno1
#MAN=enp2s0f1 #Mereyem
#WAN=enp3s0
#WLAN=enp1s0  #ASUS enp1s0
#VPN=esp
#LOOP=lo
#LAN_IP=192.168.14.254
#WLAN_IP=192.168.77.254
#WAN_IP=192.168.0.80
#LOOP_IP=127.0.0.1
#MAN_IP=192.168.8.254
#
# Clear all previous rules.
sudo iptables -F

# Default policy.
sudo iptables --policy INPUT ACCEPT
sudo iptables --policy OUTPUT ACCEPT
sudo iptables --policy FORWARD DROP
sudo iptables -L -v
sudo iptables -L | grep policy

# # Drop any tcp packet that does not start a connection with a syn flag.
 sudo iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

# # Drop any invalid packet that could not be identified.
 sudo iptables -A INPUT -m state --state INVALID -j DROP

# # Drop invalid packets.
# sudo iptables -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
# sudo iptables -A INPUT -p tcp -m tcp --tcp-flags SYN,FIN SYN,FIN              -j DROP
# sudo iptables -A INPUT -p tcp -m tcp --tcp-flags SYN,RST SYN,RST              -j DROP
# sudo iptables -A INPUT -p tcp -m tcp --tcp-flags FIN,RST FIN,RST              -j DROP
# sudo iptables -A INPUT -p tcp -m tcp --tcp-flags ACK,FIN FIN                  -j DROP
# sudo iptables -A INPUT -p tcp -m tcp --tcp-flags ACK,URG URG                  -j DROP

# # Reject broadcasts to 224.0.0.1
# sudo iptables -A INPUT -s 224.0.0.0/4 -j DROP
# sudo iptables -A INPUT -d 224.0.0.0/4 -j DROP
# sudo iptables -A INPUT -s 240.0.0.0/5 -j DROP

# # Drop everything that did not match above or drop and log it.
# sudo iptables -A INPUT   -j LOG --log-level 4 --log-prefix "IPTABLES_INPUT: "
# sudo iptables -A INPUT   -j DROP
# sudo iptables -A FORWARD -j LOG --log-level 4 --log-prefix "IPTABLES_FORWARD: "
# sudo iptables -A FORWARD -j DROP
# sudo iptables -A OUTPUT  -j LOG --log-level 4 --log-prefix "IPTABLES_OUTPUT: "
# sudo iptables -A OUTPUT  -j ACCEPT

# # Block Webmin on WAN
# #sudo iptables -A INPUT -i $WAN -p tcp -m state --state NEW,ESTABLISHED,RELATED --dport 10000 -j DROP
# #sudo iptables -A OUTPUT -o $WAN -p tcp -m state --state NEW,ESTABLISHED,RELATED --dport 10000 -j DROP

# # Apt-Get without problem
# #sudo iptables -A OUTPUT -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
# #sudo iptables -A OUTPUT -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
# #sudo iptables -A INPUT -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT
# #sudo iptables -A INPUT -p tcp --sport 443 -m state --state ESTABLISHED -j ACCEPT

# # Allow Plex
# #sudo iptables -A INPUT -i $WAN -p tcp -m state --state NEW,ESTABLISHED,RELATED --dport 32400 -j ACCEPT
# #sudo iptables -A OUTPUT -o $WAN -p tcp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# # Allow TEAMVIEWER on LAN
# #sudo iptables -A OUTPUT -o $LAN -p tcp --dport 5938 -m state --state NEW -j ACCEPT
# #sudo iptables -A OUTPUT -o $LAN -m state --state NEW,ESTABLISHED -p tcp -m tcp -m multiport --dports 5938,443,80 -j ACCEPT
# #sudo iptables -A INPUT -i $LAN -m state --state NEW -m tcp -p tcp -m multiport --dports 5900:5913,6000:6013 -j ACCEPT
# #sudo iptables -A INPUT -i $LAN -m state --state ESTABLISHED -p tcp -m tcp -m multiport --dports 5938,443,80 -j ACCEPT

# # Allow anything over loopback and vpn.
# sudo iptables -A INPUT -i $LOOP -s $LOOP_IP -d $LOOP_IP -j ACCEPT
# sudo iptables -A OUTPUT -o $LOOP -s $LOOP_IP -d $LOOP_IP -j ACCEPT
# sudo iptables -A INPUT -p $VPN -j ACCEPT
# sudo iptables -A OUTPUT -p $VPN -j ACCEPT

# #accept related and established connection
# sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# sudo iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# # Allow TCP/UDP connections out. Keep state so conns out are allowed back in.
# sudo iptables -A INPUT  -p tcp -m state --state ESTABLISHED     -j ACCEPT
# sudo iptables -A OUTPUT -p tcp -m state --state NEW,ESTABLISHED -j ACCEPT
# sudo iptables -A INPUT  -p udp -m state --state ESTABLISHED     -j ACCEPT
# sudo iptables -A OUTPUT -p udp -m state --state NEW,ESTABLISHED -j ACCEPT

# # Allow only ICMP echo requests (ping) in. Limit rate in.
# sudo iptables -A INPUT  -p icmp -m state --state NEW,ESTABLISHED --icmp-type echo-reply -j ACCEPT
# sudo iptables -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED --icmp-type echo-request -j ACCEPT

# # Block ICMP allow only ping out
# #sudo iptables -A INPUT  -p icmp -m state --state NEW -j DROP
# #sudo iptables -A INPUT  -p icmp -m state --state ESTABLISHED -j ACCEPT
# #sudo iptables -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED -j ACCEPT

# # Allow ssh connections in.
# #sudo iptables -A INPUT -p tcp -s $LAN_IP -m tcp --dport 22 -m state --state NEW,ESTABLISHED,RELATED -m limit --limit 2/m -j ACCEPT

# # DNS
# #sudo iptables -A INPUT -p tcp -m tcp --sport 53 -j ACCEPT
# #sudo iptables -A INPUT -p udp -m udp --sport 53 -j ACCEPT
# #sudo iptables -A OUTPUT -p tcp -m tcp --dport 53 -j ACCEPT
# #sudo iptables -A OUTPUT -p udp -m udp --dport 53 -j ACCEPT

# # WWW
# #sudo iptables -A INPUT -p tcp --dport 80 -m state --state NEW -j ACCEPT
# #sudo iptables -A OUTPUT -p tcp --dport 80 -m state --state NEW -j ACCEPT

# #allow traffic going to specific outbound ports
# #sudo iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
# #sudo iptables -A INPUT -p tcp --sport 80 -j ACCEPT

# #sudo iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
# #sudo iptables -A INPUT -p tcp --sport 443 -j ACCEPT

# #sudo iptables -A OUTPUT -p tcp --dport 5938 -j ACCEPT
# #sudo iptables -A INPUT -p tcp --sport 5938 -j ACCEPT


# #systemd-resolve --status



# ip route add 192.168.14.0/24 via 192.168.14.254 dev $LAN

# route add default gw 192.168.0.1
# #route add default gw 192.168.14.254
# #route del default gw 192.168.14.254

netstat -rn
##/***/
#echo 1 > /proc/sys/net/ipv4/ip_forward
#Or we can set the forwarding by editing the file /etc/sysctl.conf.
#We find the line and replace 0 with 1.
#net.ipv4.ip_forward = 1
##/****/
#Make sure that your rule has been configured successfully.
# sudo iptables -t nat -L
#Also, you can see if traffic is passing through the rule in the POSTROUTING chain by running this command in our shell terminal:
# sudo iptables -t nat -L -v
#
##/*this will keep MAN from accessing LAN**/
sudo iptables -t nat -A POSTROUTING -o $WAN -j MASQUERADE
sudo iptables -A FORWARD -i $WAN -o $MAN -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i $MAN -o $WAN -j ACCEPT
#
##/*this will keep WLAN from accessing LAN**/
sudo iptables -t nat -A POSTROUTING -o $WAN -j MASQUERADE
sudo iptables -A FORWARD -i $WAN -o $LAN -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i $LAN -o $WAN -j ACCEPT
#DMZ
sudo iptables -A FORWARD -i $WAN -o $WLAN -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i $WLAN -o $WAN -j ACCEPT
#
##/**This will let WLAN access LAN**/
sudo iptables -t nat -A POSTROUTING -o $WAN -j MASQUERADE
sudo iptables -A FORWARD -i $WAN -o $LAN -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i $LAN -o $WAN -j ACCEPT
#DMZ
sudo iptables -A FORWARD -i $LAN -o $WLAN -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i $WLAN -o $LAN -j ACCEPT

##/**/
# sudo iptables -t nat -A POSTROUTING -o enp6s0 -j MASQUERADE
# sudo iptables -A FORWARD -i enp6s0 -o enp5s0 -m state --state RELATED,ESTABLISHED -j ACCEPT
# sudo iptables -A FORWARD -i enp5s0 -o enp6s0 -j ACCEPT
# #DMZ
# sudo iptables -A FORWARD -i enp6s0 -o enp7s0 -m state --state RELATED,ESTABLISHED -j ACCEPT
# sudo iptables -A FORWARD -i enp7s0 -o enp6s0 -j ACCEPT

#/etc/iptables/rules.v4
#/etc/iptables/rules.v6
sudo mkdir -p /etc/iptables
sudo iptables-save > /etc/iptables/rules.v4
#OR
# ip6tables-save > /etc/iptables/rules.v6

#iptables-save > /dev/null 2>&1

# SAVE
sudo iptables-save
systemctl restart docker
