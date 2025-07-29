clear
#
#ansible-inventory -y --list
#
mkdir -p /home/ibrahim/log/
touch /home/ibrahim/log/ansible_log.yml
chmod 666 /home/ibrahim/log/ansible_log.yml
#
#ansible-playbook -v run-main.yml # works
#ansible-playbook --limit "gh-servers" run-main.yml # works
#ansible-playbook -v --limit gh-servers run-main.yml --list-host # works
ansible-playbook --limit gh-servers run-main.yml # works
#ansible-playbook -v gh-servers run-main.yml # works
#
#ansible-galaxy collection install -r requirements.yml
#ansible-galaxy collection install community.healthchecksio --upgrade