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
# ***
# To see the ‘raw’ information as gathered, run this command at the command line:
# ansible <hostname> -m ansible.builtin.setup
# https://docs.ansible.com/ansible/lalocalhost/playbook_guide/playbooks_vars_facts.html
# ***

# Multi-server localhosts for the orchestration example.
#set -e
##ansible-inventory -y --list
# Other commands from the book.
#ansible-playbook -v run-dockers.yml # works
###ansible-playbook -v --tags localhost run-main.yml # works
#ansible-playbook -v --tags localhost -c local run-main.yml # works
#ansible-playbook -v -i localhost-inv.yml run-main.yml # works
#ansible-playbook -vv --tags localhost run-main.yml # works
#ansible-playbook -vv --tags servercleanup run-main.yml # works
#ansible-playbook -vv --tags gpt run-main.yml # works
#ansible-playbook --tags healthcheck --limit 4a999ff run-main.yml # works
##ansible-playbook -v --tags localhost --limit !gh-servers run-main.yml # works
#ansible-playbook -v --tags localhost -i localhost-inv.yml run-main.yml # works
#ansible-playbook -v --tags localhost run-provisions.yml # works
#ansible-playbook -v run-anydesk.yml # works
#ansible-playbook -v run-apt.yml # works
#ansible-playbook -v run-proxmox.yml # works
#ansible-playbook -i localhost-inv.yml run-main.yml # works
#ansible-playbook --limit vms run-main.yml # works
#ansible-playbook -c local localhost.yml # works
#ansible-playbook localhost.yml # works

# export ANSIBLE_VAULT_PASSWORD_FILE=~/.vault_pass
# echo "${ANSIBLE_VAULT_PASSWORD}" > "${ANSIBLE_VAULT_PASSWORD_FILE}"
# ansible-playbook site.yml
#
# Setup logging: create logs dir and timestamped logfile
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"
mkdir -p "$LOG_DIR"
LOGFILE="$LOG_DIR/run-localhost-$(date +%Y%m%d-%H%M%S).log"
ln -sf "$LOGFILE" "$LOG_DIR/latest-run-localhost.log"
echo "Logging ansible output to $LOGFILE"

# Run playbook and write both stdout and stderr to the timestamped log (also show on console)
#ansible-playbook -v --limit '!gh-servers' run-dockers.yml 2>&1 | tee -a "$LOGFILE"
#ansible-playbook -v --tags localhost -l localhost --limit !gh-servers run-main.yml --check --diff 2>&1 | tee -a "$LOGFILE" # works
ansible-playbook -v --tags localhost --limit localhost run-main.yml --check --diff --step 2>&1 | tee -a "$LOGFILE" # works


#1. Basic Dry‑Run (Check Mode)
#ansible-playbook myplaybook.yml --check
#2. Dry‑Run With Diff Output
#ansible-playbook myplaybook.yml --check --diff
#3. Limit Dry‑Run to One Host (Optional)
#ansible-playbook myplaybook.yml --check -l myserver01