#ip route delete default
sudo route add default gw 192.168.1.1
ping -w 3 8.8.8.8 -I eno1   # LAN
ping -w 3 8.8.8.8 -I enp2s0 # WLAN
ping -w 3 8.8.8.8 -I enp5s0 # WAN
