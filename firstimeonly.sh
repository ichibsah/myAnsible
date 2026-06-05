clear
# docker build -t docker-agent-ansible:latest . 
# docker image tag docker-agent-ansible:latest docker.io/michibsah/docker-agent-ansible:latest
# docker login -u michibsah
# docker push docker.io/michibsah/docker-agent-ansible:latest
#
ansible-inventory -y --list
#
##ansible-playbook -vvvv run-firstimeonly.yml # works
#ansible-playbook -v --limit a35a0d3 run-firstimeonly.yml # works

# apt-get install qemu-system
# apt install cloud-init
# apt inatll 

# curl -s https://packagecloud.io/install/repositories/crowdsec/crowdsec/script.deb.sh | sudo bash
# sudo apt-get install crowdsec
# sudo apt install crowdsec-firewall-bouncer-iptables
# sudo cscli console enroll clktqwcri0000lb084lgn6tey
# apt-get install qemu-system
# sudo apt install cloud-init

# ssh-keygen -f "/home/ibrahim/.ssh/known_hosts" -R "a35a0d3.imsawadogo.com"
# Setup logging: create logs dir and timestamped logfile
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"
mkdir -p "$LOG_DIR"
LOGFILE="$LOG_DIR/first-time-only-$(date +%Y%m%d-%H%M%S).log"
ln -sf "$LOGFILE" "$LOG_DIR/latest-first-time-only.log"
echo "Logging ansible output to $LOGFILE"

#ansible-playbook -v --limit !gh-servers run-main.yml --list-host # works
#ansible-playbook -v --limit !gh-servers run-main.yml # works
ansible-playbook -v --limit '!gh-servers !localhost' run-firstimeonly.yml 2>&1 | tee -a "$LOGFILE" # works