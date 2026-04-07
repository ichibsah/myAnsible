ip6tables -P INPUT DROP
ip6tables -P OUTPUT ACCEPT
ip6tables -P FORWARD DROP

ip6tables -F
ip6tables -t nat -F

# Allow loopback
ip6tables -A INPUT -i lo -j ACCEPT

# Drop invalid
ip6tables -A INPUT -m conntrack --ctstate INVALID -j DROP

# Allow established
ip6tables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
ip6tables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# ICMPv6 required for IPv6 to function correctly
ip6tables -A INPUT -p ipv6-icmp -j ACCEPT

# LAN → WAN
ip6tables -A FORWARD -i $LAN -o $WAN -j ACCEPT

# MAN/WLAN restrictions same concept as IPv4
ip6tables -A FORWARD -i $MAN -o $LAN -j DROP
ip6tables -A FORWARD -i $WLAN -o $LAN -j DROP
ip6tables -A FORWARD -i $WLAN -o $MAN -j DROP