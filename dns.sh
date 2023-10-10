clear
# docker build -t docker-agent-ansible:latest . 
# docker image tag docker-agent-ansible:latest docker.io/michibsah/docker-agent-ansible:latest
# docker login -u michibsah
# docker push docker.io/michibsah/docker-agent-ansible:latest
#
ansible-inventory -y --list
#
ansible-playbook -v --tags dns run-main.yml # works
#
# nslookup pihole.skyline.lan 10.0.0.136
nslookup pihole.skyline.lan 10.0.0.136
