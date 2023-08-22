docker build -t docker-agent-ansible:latest . 
docker image tag docker-agent-ansible:latest docker.io/michibsah/docker-agent-ansible:latest
docker login -u michibsah
docker push docker.io/michibsah/docker-agent-ansible:latest
