#!/bin/bash 

# https://www.cyberciti.biz/tips/shell-scripting-creating-reportlog-file-names-with-date-in-filename.html

## purpose of this script 
# cronjob - run every minute and create an houly log.
# 1. test default gateway is up, if fails, add default gateway.
# 2. ping v.router but firewall gateway must be active, if fails restart router remotely.
# 3.
# 4. check nic speed, if less than 1Gbps, restart network card, then add default gateway

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


#HOSTIP=`ifconfig eno1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
RED='\033[0;31m'
NOCOLOR='\033[0m'
#echo -e "I ${RED}love${NOCOLOR} Linux"
mkdir -p ./logs
#touch "mylog-$(date +%F)"
FileName=mylog-`date +%F`
LOG=./logs/$FileName
SECONDS=3600 
EMAIL=ibrahim@skyline.lan
FwGatewayIP=192.168.0.80
FwGatewayIPDown=false
RtGatewayIP=192.168.0.1
RtGatewayIPDown=false
resetNetwork=false
resetDefGateway=false
resetRouter=false
#FwGatewayIPNIC=enp2s0f1
#FwGatewayIPNIC=enp4s0
FwGatewayIPNIC=$(ip2inet $FwGatewayIP)  #enp4s0
googleIP=1.1.1.1
#
# 01 test firewall gateway
#ping -c 1 $FwGatewayIP # debug script only
ping -c 1 $FwGatewayIP > /dev/null
if [ $? -ne 0 ]; then 
	FwGatewayIPDown=true
	resetNetwork=true
	resetDefGateway=true
	echo -e "`date` -${RED} $FwGatewayIP is DOWN!${NOCOLOR}" >> $LOG
else
	echo "`date` - $FwGatewayIP-UP!" >> $LOG
fi

# 02 test Router gateway
ping -c 1 $RtGatewayIP > /dev/null
if [ $? -ne 0 ]; then 
	if [ $FwGatewayIPDown = "false" ]; then
		RtGatewayIPDown=true
		resetDefGateway=true
		echo "`date` - $RtGatewayIP-DOWN!" >> $LOG
	else
		echo "`date` - unconclusive - $FwGatewayIP is DOWN! so $RtGatewayIP is not reachable" >> $LOG
	fi
else
		echo "`date` - $RtGatewayIP-UP!" >> $LOG
fi

#3. ping Google ip its down, reset the default gateway
ping -c 1 $googleIP > /dev/null
if [ $? -ne 0 ]; then 
	googleIPDown=true
	resetDefGateway=true
	#resetRouter=true
	echo -e "`date` - ${RED} $googleIP-DOWN! ${NOCOLOR}" >> $LOG
else
	echo "`date` - $googleIP-UP!" >> $LOG
fi

# 4. check nic speed, if less than 1Gbps, restart network card, then add default gateway
# Get the current speed of network card eno1 and store in variable
speed=$(ethtool $FwGatewayIPNIC | grep Speed | awk '{print $2}')

# Split speed and unit into separate variables
value=$(echo $speed | grep -o '[0-9]*')
unit=$(echo $speed | grep -o '[A-Za-z]*')

# Print the speed value and unit separately
echo -e "`date` - Network card $FwGatewayIPNIC speed is: $speed" >> $LOG




### ACTION ###
if [ $resetNetwork = "true" ]; then
	ip link set $FwGatewayIPNIC down
	ip link set $FwGatewayIPNIC up
	echo "`date` - NIC '$FwGatewayIPNIC' was reset" >> $LOG
fi
if [ $resetDefGateway = "true" ]; then
	sudo route add default gw $RtGatewayIP
	echo "`date` - Def Gateway was reset" >> $LOG
fi
if [ $resetRouter = "true" ]; then
	###Restart router remotely###
	echo "`date` - Router was reset - not really" >> $LOG
fi

# Initialize to a value that would force a restart
# (just in case ping gives an error and ploss doesn't get set)

#ploss=101
# now ping google for 10 seconds and count packet loss
# ploss=$(ping -q -w10 www.google.com | grep -o "[0-9]*%" | tr -d %) > /dev/null 2>&1

# if [ "$ploss" -gt "$maxPloss" ]; then
#         logger "Packet loss ($ploss%) exceeded $maxPloss, restarting network ..."
#         restart_networking
# fi
echo "*****************************************" >> $LOG
