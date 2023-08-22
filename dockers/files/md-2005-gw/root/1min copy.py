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

def ping_target(target):
    """
    Executes ping command and return True if successful, False otherwise
    """
    ping_command = f"ping -c 1 {target}"
    ping_result = subprocess.call(ping_command.split(), stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    return ping_result == 0

def reset_network_interface(interface):
    """
    Resets the specified network interface by setting it down and then up
    """
    subprocess.call(["ip", "link", "set", interface, "down"])
    subprocess.call(["ip", "link", "set", interface, "up"])

def configure_default_gateway(gateway):
    """
    Configures the default gateway to the specified gateway address
    """
    subprocess.call(["sudo", "route", "add", "default", "gw", gateway])

def create_log_file():
    """
    Creates a log file with the current date and time formatted as %Y-%m-%d
    """
    log_dir = "./logs"
    subprocess.call(["mkdir", "-p", log_dir])
    filename = "mylog-" + datetime.now().strftime("%Y-%m-%d")
    log_path = f"{log_dir}/{filename}"
    with open(log_path, "a") as f:
        f.write("")
    return log_path

def log_message(msg, color='\033[0m'):
    """
    Logs the message to the log file with the current date and time
    """
    with open(log_path, "a") as f:
        f.write(f"{datetime.now()} - {color}{msg}{NOCOLOR}\n")

RED = '\033[0;31m'
NOCOLOR = '\033[0m'

#HOSTIP = subprocess.check_output("ifconfig eno1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'", shell=True).decode('utf-8').strip()
print(f"I {RED}love{NOCOLOR} Linux")

log_path = create_log_file()
FwGatewayIP = "192.168.0.80"
RtGatewayIP = "192.168.0.1"
googleIP = "1.1.1.1"
FwGatewayIPNIC = ip2inet(FwGatewayIP)# "enp4s0"

# 01 test firewall gateway
if not ping_target(FwGatewayIP):
    with open(log_path, "a") as f:
        f.write(f"{datetime.now()} -{RED} {FwGatewayIP} is DOWN!{NOCOLOR}\n")
        FwGatewayIPDown = True
        resetNetwork = True
else:
    with open(log_path, "a") as f:
        f.write(f"{datetime.now()} - {FwGatewayIP}-UP!\n")

# 02 test Router gateway
if not ping_target(RtGatewayIP):
    if not FwGatewayIPDown:
        with open(log_path, "a") as f:
            f.write(f"{datetime.now()} - {RtGatewayIP}-DOWN!\n")
        RtGatewayIPDown = True
        resetDefGateway = True
    else:
        with open(log_path, "a") as f:
            f.write(f"{datetime.now()} - unconclusive - {FwGatewayIP} is DOWN! so {RtGatewayIP} is not reachable\n")
else:
    with open(log_path, "a") as f:
        f.write(f"{datetime.now()} - {RtGatewayIP}-UP!\n")

#3. ping Google ip its down, reset the default gateway