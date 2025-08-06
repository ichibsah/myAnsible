# !/bin/bash
#
ip route list
#Delete the default route(s). (Warning: this will kick you offline.)
ip route del default
#Add a new default route (this will bring you back online). below, with your gateway ip address
ip route add default via 192.168.1.80 dev enp2s0
#Add a specific route that will be served by eth1. More-specific routes automatically take precedence over less-specific ones.
ip route add 10.0.0.0/14 via 192.168.1.80 dev enp2s0
#Finally, you can ask Linux which interface will be used to send a packet to a specific ip address
#If the configuration worked, packets to 8.8.8.8 (Google's server) will use eth0. Packets to any ip on your local network
ip route get 8.8.8.8
#will use enp2s0
ip route get 192.168.1.1


# root@gh-1017-gw:/root# ip route list
# default via 192.168.1.1 dev enp2s0 
# default via 192.168.1.1 dev enp2s0 onlink 
# 10.0.0.0/14 dev eno1 proto kernel scope link src 10.3.0.254 
# 172.17.0.0/16 dev docker0 proto kernel scope link src 172.17.0.1 
# 172.18.0.0/16 dev br-fc456a8eca7c proto kernel scope link src 172.18.0.1 
# 172.20.0.0/16 dev br-4e682374d1f5 proto kernel scope link src 172.20.0.1 linkdown 
# 172.23.0.0/16 dev br-cc49d750dcc9 proto kernel scope link src 172.23.0.1 
# 192.168.1.0/24 dev enp2s0 proto kernel scope link src 192.168.1.80