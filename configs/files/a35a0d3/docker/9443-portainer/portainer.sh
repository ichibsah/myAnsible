docker run -d \
    --name portainer \
    --restart=always \
    -p 8000:8000 \
    -p 9443:9443 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $(pwd)/docker/data:/data:rw \
    portainer/portainer-ce:latest
#    portainer/portainer-ce:2.9.3