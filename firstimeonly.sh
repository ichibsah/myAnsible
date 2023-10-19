clear
# docker build -t docker-agent-ansible:latest . 
# docker image tag docker-agent-ansible:latest docker.io/michibsah/docker-agent-ansible:latest
# docker login -u michibsah
# docker push docker.io/michibsah/docker-agent-ansible:latest
#
#ansible-inventory -y --list
#
ansible-playbook -v run-firstimeonly.yml # works
#ansible-playbook -v --limit a35a0d3 run-firstimeonly.yml # works

# apt-get install qemu-system
# apt install cloud-init
# apt inatll 

# curl -s https://packagecloud.io/install/repositories/crowdsec/crowdsec/script.deb.sh | sudo bash
# sudo apt-get install crowdsec
# sudo apt install crowdsec-firewall-bouncer-iptables
# sudo cscli console enroll clktqwcri0000lb084lgn6tey
# apt-get install qemu-system
# sudo apt install cloud-init

# ssh-keygen -f "/home/ibrahim/.ssh/known_hosts" -R "a35a0d3.online-server.cloud"