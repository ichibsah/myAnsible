#!/usr/bin/env python3
import json
import subprocess
import sys

subnets = [
    "192.168.77.0/24",
    "192.168.8.0/24",
    "10.0.0.0/24"
]

def run_nmap():
    cmd = ["nmap", "-O", "-p", "22,80,443,5985,5986", "--open"] + subnets
    result = subprocess.run(cmd, capture_output=True, text=True)
    return result.stdout

def parse_nmap_output(output):
    hosts = []
    current_ip = None
    open_ports = []
    os_name = "unknown"

    for line in output.splitlines():
        if "Nmap scan report for" in line:
            if current_ip:
                hosts.append((current_ip, open_ports, os_name))
            current_ip = line.split()[-1]
            open_ports = []
            os_name = "unknown"

        if "/tcp" in line and "open" in line:
            port = int(line.split('/')[0])
            open_ports.append(port)

        if "OS details:" in line:
            os_name = line.replace("OS details:", "").strip()

    if current_ip:
        hosts.append((current_ip, open_ports, os_name))

    return hosts

def generate_inventory(hosts):
    inventory = {
        "_meta": {"hostvars": {}},
        "all": {"hosts": []},
        "ssh_hosts": {"hosts": []},
        "web_servers": {"hosts": []},
        "windows": {"hosts": []},
        "linux": {"hosts": []},
        "winrm_hosts": {"hosts": []}
    }

    for host, ports, os_name in hosts:
        inventory["all"]["hosts"].append(host)

        if 22 in ports:
            inventory["ssh_hosts"]["hosts"].append(host)
        if 80 in ports or 443 in ports:
            inventory["web_servers"]["hosts"].append(host)
        if 5985 in ports or 5986 in ports:
            inventory["winrm_hosts"]["hosts"].append(host)

        if "Linux" in os_name:
            inventory["linux"]["hosts"].append(host)
        if "Windows" in os_name:
            inventory["windows"]["hosts"].append(host)

        inventory["_meta"]["hostvars"][host] = {"ansible_host": host}

    return inventory

if __name__ == "__main__":
    output = run_nmap()
    hosts = parse_nmap_output(output)
    inventory = generate_inventory(hosts)
    print(json.dumps(inventory, indent=2))