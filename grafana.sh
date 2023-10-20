#!/bin/bash
#
clear
ansible-inventory -y --list

ansible-playbook -v --tags grafana run-main.yml # works
