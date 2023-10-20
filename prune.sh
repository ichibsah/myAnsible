#!/bin/bash
#
clear
ansible-inventory -y --list

ansible-playbook -v --tags prune run-main.yml # works
