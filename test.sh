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

# Multi-server tests for the orchestration example.
#set -e
##ansible-inventory -y --list
# Other commands from the book.
#ansible-playbook -v run-dockers.yml # works
###ansible-playbook -v --tags test run-main.yml # works
#ansible-playbook -v --tags test -c local run-main.yml # works
#ansible-playbook -v -i test-inv.yml run-main.yml # works
#ansible-playbook -vv --tags test run-main.yml # works
#ansible-playbook -vv --tags servercleanup run-main.yml # works
#ansible-playbook -vv --tags gpt run-main.yml # works
#ansible-playbook --tags healthcheck --limit 4a999ff run-main.yml # works
ansible-playbook -v --tags test run-main.yml # works
#ansible-playbook -v --tags test -i test-inv.yml run-main.yml # works
#ansible-playbook -v --tags test run-provisions.yml # works
#ansible-playbook -v run-anydesk.yml # works
#ansible-playbook -v run-apt.yml # works
#ansible-playbook -v run-proxmox.yml # works
#ansible-playbook -i test-inv.yml run-main.yml # works
#ansible-playbook --limit vms run-main.yml # works
#ansible-playbook -c local test.yml # works
#ansible-playbook test.yml # works

# export ANSIBLE_VAULT_PASSWORD_FILE=~/.vault_pass
# echo "${ANSIBLE_VAULT_PASSWORD}" > "${ANSIBLE_VAULT_PASSWORD_FILE}"
# ansible-playbook site.yml