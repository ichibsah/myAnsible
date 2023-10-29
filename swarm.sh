#!/bin/bash
#
clear
ansible-inventory -y --list

ansible-playbook -v --tags swarm run-main.yml # works
