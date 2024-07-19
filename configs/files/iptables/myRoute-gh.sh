# !/bin/bash
#
ip route list
#Delete the default route(s). (Warning: this will kick you offline.)
ip route del default
#Add a new default route (this will bring you back online). below, with your gateway ip address
ip route add default via 192.168.1.80 dev enp5s0
#Add a specific route that will be served by eth1. More-specific routes automatically take precedence over less-specific ones.
ip route add 10.0.0.0/14 via 192.168.1.80 dev enp5s0
#Finally, you can ask Linux which interface will be used to send a packet to a specific ip address
#If the configuration worked, packets to 8.8.8.8 (Google's server) will use eth0. Packets to any ip on your local network
ip route get 8.8.8.8
#will use enp5s0
ip route get 192.168.1.1

