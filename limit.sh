clear
# docker build -t docker-agent-ansible:latest . 
# docker image tag docker-agent-ansible:latest docker.io/michibsah/docker-agent-ansible:latest
# docker login -u michibsah
# docker push docker.io/michibsah/docker-agent-ansible:latest
#
ansible-inventory -y --list
#
ansible-playbook -v --limit a35a0d3.online-server.cloud run-main.yml # works
#ansible-playbook -v --limit a35a0d3.online-server.cloud -t ~/log/ansible-$($date) run-main.yml # works
#ansible-playbook -v --limit a35a0d3 run-main.yml # works