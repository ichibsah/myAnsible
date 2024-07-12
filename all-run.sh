clear
# docker build -t docker-agent-ansible:latest . 
# docker image tag docker-agent-ansible:latest docker.io/michibsah/docker-agent-ansible:latest
# docker login -u michibsah
# docker push docker.io/michibsah/docker-agent-ansible:latest
#
ansible-inventory -y --list
#
#ansible-playbook -v --limit !gh-servers run-main.yml --list-host # works
ansible-playbook -v --limit !gh-servers run-main.yml # works