#!/bin/bash
#
clear
#
ansible all -m ansible.builtin.setup --flush-cache
rm -rf ~/.ansible/facts_cache/
rm -rf ~/.ansible/tmp/
rm -rf /tmp/.ansible-*
#
ansible-galaxy collection install -r collections/requirements.yml
#
ansible-inventory -y --list
# ***
# Setup logging: create logs dir and timestamped logfile
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"
mkdir -p "$LOG_DIR"
LOGFILE="$LOG_DIR/run-test-$(date +%Y%m%d-%H%M%S).log"
ln -sf "$LOGFILE" "$LOG_DIR/latest-run-test.log"
echo "Logging ansible output to $LOGFILE"
#
if [[ $# -gt 0 ]]; then
    ansible-playbook -v --tags test --limit '!gh-servers !localhost' run-main.yml 2>&1 | tee -a "$LOGFILE" # works
else
    # ansible-playbook -v --tags test --limit '!gh-servers !localhost' run-main.yml # works
    #ansible-playbook -i inventories/routeros/hosts.yml site.yml --ask-vault-pass --check

    ansible-playbook -v -i inventories/routeros/hosts.yml run-routeros.yml --check # works
fi
