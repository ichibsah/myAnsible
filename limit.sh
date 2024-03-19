clear
# docker build -t docker-agent-ansible:latest . 
# docker image tag docker-agent-ansible:latest docker.io/michibsah/docker-agent-ansible:latest
# docker login -u michibsah
# docker push docker.io/michibsah/docker-agent-ansible:latest
#
ansible-inventory -y --list
#
#ansible-playbook -v --limit deb1202 run-hostname.yml # works
#ansible-playbook -v --limit de-1007-docker run-main.yml # works
ansible-playbook -v --limit gh-dev-xl run-main.yml # works
#ansible-playbook -v --limit 112e275 run-main.yml # works
#ansible-playbook -v --limit de-jump run-main.yml # works
#ansible-playbook -v --limit a35a0d3.online-server.cloud -t ~/log/ansible-$($date) run-main.yml # works
#ansible-playbook -v --limit a35a0d3 run-main.yml # works