#!/bin/bash
#
clear
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INVENTORY="$SCRIPT_DIR/inventories/routeros/hosts.yml"
VENV_DIR="$SCRIPT_DIR/.venv"
PYTHON="$VENV_DIR/bin/python"
ANSIBLE="$VENV_DIR/bin/ansible"
ANSIBLE_PLAYBOOK="$VENV_DIR/bin/ansible-playbook"
ANSIBLE_GALAXY="$VENV_DIR/bin/ansible-galaxy"

if [[ ! -x "$PYTHON" ]]; then
    python3 -m venv "$VENV_DIR"
fi

"$PYTHON" -m pip install --upgrade pip
"$PYTHON" -m pip install "ansible-core>=2.16,<2.17" ansible-pylibssh paramiko

"$ANSIBLE_GALAXY" collection install -r "$SCRIPT_DIR/collections/requirements.yml" --force

"$ANSIBLE" -i "$INVENTORY" all -m ansible.builtin.setup
rm -rf ~/.ansible/facts_cache/
rm -rf ~/.ansible/tmp/
rm -rf /tmp/.ansible-*
#
"$PYTHON" -c "import pylibsshext; print('ansible-pylibssh installed')"
"$PYTHON" -c "import paramiko; print(paramiko.__version__)"
#
"$VENV_DIR/bin/ansible-inventory" -i "$INVENTORY" -y --list
# ***
# Setup logging: create logs dir and timestamped logfile
LOG_DIR="$SCRIPT_DIR/logs"
mkdir -p "$LOG_DIR"
LOGFILE="$LOG_DIR/run-test-$(date +%Y%m%d-%H%M%S).log"
ln -sf "$LOGFILE" "$LOG_DIR/latest-run-test.log"
echo "Logging ansible output to $LOGFILE"
#
if [[ $# -gt 0 ]]; then
    #"$ANSIBLE_PLAYBOOK" -v --tags test --limit '!gh-servers !localhost' run-main.yml 2>&1 | tee -a "$LOGFILE" # works
    :
else
    # ansible-playbook -v --tags test --limit '!gh-servers !localhost' run-main.yml # works
    #ansible-playbook -i inventories/routeros/hosts.yml site.yml --ask-vault-pass --check

    # ansible-playbook -v -i inventories/routeros/hosts.yml run-routeros.yml --check # works
    "$ANSIBLE_PLAYBOOK" -v -i "$INVENTORY" --tags ssh run-routeros.yml # works
    "$ANSIBLE_PLAYBOOK" -v -i "$INVENTORY" run-routeros.yml # works
fi
