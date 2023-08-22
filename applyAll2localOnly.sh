#!/bin/bash
#
# Multi-server tests for the orchestration example.
#set -e
ansible-inventory --list
# Other commands from the book.

ansible-playbook applyAll2localOnly.yml # works
#ansible-playbook test.yml # works

# export ANSIBLE_VAULT_PASSWORD_FILE=~/.vault_pass
# echo "${ANSIBLE_VAULT_PASSWORD}" > "${ANSIBLE_VAULT_PASSWORD_FILE}"
# ansible-playbook site.yml