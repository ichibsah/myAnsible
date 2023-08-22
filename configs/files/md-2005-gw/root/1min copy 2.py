import subprocess
from datetime import datetime, timedelta


class NetworkUtility:
    RED = '\033[0;31m'
    NOCOLOR = '\033[0m'
    
    def __init__(self):
        self.log_path = self.create_log_file()
        self.FwGatewayIP = "192.168.0.80"
        self.RtGatewayIP = "192.168.0.1"
        self.googleIP = "1.1.1.1"
        self.FwGatewayIPNIC = self.ip2inet(self.FwGatewayIP)
        self.FwGatewayIPDown = False
        self.RtGatewayIPDown = False
        self.resetNetwork = False
        self.resetDefGateway = False
        
    def ip2inet(self, input):
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

    def create_log_file(self):
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
    
    def reset_network_interface(self, interface):
        """
        Resets the specified network interface by setting it down and then up
        """
        subprocess.call(["ip", "link", "set", interface, "down"])
        subprocess.call(["ip", "link", "set", interface, "up"])

    def configure_default_gateway(self, gateway):
        """
        Configures the default gateway to the specified gateway address
        """
        subprocess.call(["sudo", "route", "add", "default", "gw", gateway])

    def ping_target(self, target):
        """
        Executes ping command and return True if successful, False otherwise
        """
        ping_command = f"ping -c 1 {target}"
        ping_result = subprocess.call(ping_command.split(), stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        return ping_result == 0
    
    def log_message(self, msg, color=NOCOLOR):
        """
        Logs the message to the log file with the current date and time
        """
        with open(self.log_path, "a") as f:
            f.write(f"{datetime.now()} - {color}{msg}{self.NOCOLOR}\n")
            
    def test_firewall_gateway(self):
        if not self.ping_target(self.FwGatewayIP):
            with open(self.log_path, "a") as f:
                f.write(f"{datetime.now()} -{self.RED} {self.FwGatewayIP} is DOWN!{self.NOCOLOR}\n")
            self.FwGatewayIPDown = True
            self.resetNetwork = True
        else:
            with open(self.log_path, "a") as f:
                f.write(f"{datetime.now()} - {self.FwGatewayIP}-UP!\n")
            
    def test_router_gateway(self):
        if not self.ping_target(self.RtGatewayIP):
            if not self.FwGatewayIPDown:
                with open(self.log_path, "a") as f:
                    f.write(f"{datetime.now()} - {self.RtGatewayIP}-DOWN!\n")
                self.RtGatewayIPDown = True
                self.resetDefGateway = True
            else:
                with open(self.log_path, "a") as f:
                    f.write(f"{datetime.now()} - unconclusive - {self.FwGatewayIP} is DOWN! so {self.RtGatewayIP} is not reachable\n")
        else:
            with open(self.log_path, "a")
            