import subprocess
from datetime import datetime, timedelta

def ip2inet(input):
    if re.match("^([0-9]{1,3}\.){3}[0-9]{1,3}$", input):
        # If input is an IP address, retrieve the interface name
        command = "ip -o addr show | grep {} | awk '{{print $2}}'".format(input)
        name = subprocess.check_output(command, shell=True).decode('utf-8').strip()
        return name
    elif subprocess.call(["ip", "-o", "link", "show", "|", "grep", "-w", input]) == 0:
        # If input is an interface name, retrieve the IP address
        command = "ip -o addr show {} | awk '{{print $4}}' | cut -d/ -f1".format(input)
        ip = subprocess.check_output(command, shell=True).decode('utf-8').strip()
        return ip
    else:
        # If input is neither an IP address nor an interface name, print an error message
        print("Invalid input")
        return False

RED = '\033[0;31m'
NOCOLOR = '\033[0m'

#HOSTIP = subprocess.check_output("ifconfig eno1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'", shell=True).decode('utf-8').strip()
print(f"I {RED}love{NOCOLOR} Linux")

# create logs directory if it doesn't already exist
log_dir = "./logs"
subprocess.call(["mkdir", "-p", log_dir])

# create log file
filename = "mylog-" + datetime.now().strftime("%Y-%m-%d")
log_path = f"{log_dir}/{filename}"
with open(log_path, "a") as f:
    f.write("")

SECONDS = 3600
EMAIL = "ibrahim@skyline.lan"
FwGatewayIP = "192.168.0.80"
FwGatewayIPDown = False
RtGatewayIP = "192.168.0.1"
RtGatewayIPDown = False
resetNetwork = False
resetDefGateway = False
resetRouter = False
#FwGatewayIPNIC=enp2s0f1
#FwGatewayIPNIC=enp4s0
FwGatewayIPNIC = ip2inet(FwGatewayIP)# "enp4s0"

googleIP = "1.1.1.1"

# 01 test firewall gateway
ping_command = f"ping -c 1 {FwGatewayIP}"
ping_result = subprocess.call(ping_command.split(), stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
if ping_result != 0:
	FwGatewayIPDown = True
	resetNetwork = True
	with open(log_path, "a") as f:
	    f.write(f"{datetime.now()} -{RED} {FwGatewayIP} is DOWN!{NOCOLOR}\n")
else:
	with open(log_path, "a") as f:
	    f.write(f"{datetime.now()} - {FwGatewayIP}-UP!\n")

# 02 test Router gateway
ping_command = f"ping -c 1 {RtGatewayIP}"
ping_result = subprocess.call(ping_command.split(), stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
if ping_result != 0:
	if not FwGatewayIPDown:
		RtGatewayIPDown = True
		resetDefGateway = True
		with open(log_path, "a") as f:
		    f.write(f"{datetime.now()} - {RtGatewayIP}-DOWN!\n")
	else:
		with open(log_path, "a") as f:
		    f.write(f"{datetime.now()} - unconclusive - {FwGatewayIP} is DOWN! so {RtGatewayIP} is not reachable\n")
else:
	with open(log_path, "a") as f:
	    f.write(f"{datetime.now()} - {RtGatewayIP}-UP!\n")

#3. ping Google ip its down, reset the default gateway
ping_command = f"ping -c 1 {googleIP}"
ping_result = subprocess.call(ping_command.split(), stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
if ping_result != 0:
	googleIPDown = True
	resetDefGateway = True
	#resetRouter=true
	with open(log_path, "a") as f:
	    f.write(f"{datetime.now()} - {RED} {googleIP}-DOWN! {NOCOLOR}\n")
else:
	with open(log_path, "a") as f:
	    f.write(f"{datetime.now()}