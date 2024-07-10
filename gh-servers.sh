clear
#
ansible-inventory -y --list
#
#ansible-playbook -v run-main.yml # works
#ansible-playbook --limit "gh-servers" run-main.yml # works
ansible-playbook -v --limit gh-servers run-main.yml --list-host # works
#ansible-playbook -v --limit gh-servers run-main.yml # works