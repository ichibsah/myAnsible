#!/bin/bash
#
clear
#
ansible all -m ansible.builtin.setup --flush-cache
rm -rf ~/.ansible/facts_cache/
rm -rf ~/.ansible/tmp/
rm -rf /tmp/.ansible-*
#
ansible-inventory -y --list
#
# Setup logging: create logs dir and timestamped logfile
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"
mkdir -p "$LOG_DIR"
LOGFILE="$LOG_DIR/run-apt-$(date +%Y%m%d-%H%M%S).log"
ln -sf "$LOGFILE" "$LOG_DIR/latest-run-apt.log"
echo "Logging ansible output to $LOGFILE"

# Run playbook and write both stdout and stderr to the timestamped log (also show on console)
#ansible-playbook -v --limit '!gh-servers' run-dockers.yml 2>&1 | tee -a "$LOGFILE"
#ansible-playbook -v --tags apt -l apt --limit !gh-servers run-main.yml --check --diff 2>&1 | tee -a "$LOGFILE" # works
#ansible-playbook -v --limit '!gh-servers !localhost' run-apt.yml --check --diff --step 2>&1 | tee -a "$LOGFILE" # works
ansible-playbook -v --limit '!gh-servers !localhost' run-apt.yml --check --diff 2>&1 | tee -a "$LOGFILE" # works


#1. Basic Dry‑Run (Check Mode)
#ansible-playbook myplaybook.yml --check
#2. Dry‑Run With Diff Output
#ansible-playbook myplaybook.yml --check --diff
#3. Limit Dry‑Run to One Host (Optional)
#ansible-playbook myplaybook.yml --check -l myserver01
#