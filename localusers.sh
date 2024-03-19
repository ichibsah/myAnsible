#!/bin/bash
#
clear
ansible-inventory -y --list

ansible-playbook -v --tags localusers run-main.yml # works
