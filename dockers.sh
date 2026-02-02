clear
# docker build -t docker-agent-ansible:latest . 
# docker image tag docker-agent-ansible:latest docker.io/michibsah/docker-agent-ansible:latest
# docker login -u michibsah
# docker push docker.io/michibsah/docker-agent-ansible:latest
#
ansible-inventory -y --list
#
# Setup logging: create logs dir and timestamped logfile
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"
mkdir -p "$LOG_DIR"
LOGFILE="$LOG_DIR/run-dockers-$(date +%Y%m%d-%H%M%S).log"
ln -sf "$LOGFILE" "$LOG_DIR/latest-run-dockers.log"
echo "Logging ansible output to $LOGFILE"

# Run playbook and write both stdout and stderr to the timestamped log (also show on console)
ansible-playbook -v --limit '!gh-servers' run-dockers.yml 2>&1 | tee -a "$LOGFILE"
#ansible-playbook -v run-dockers.yml # works