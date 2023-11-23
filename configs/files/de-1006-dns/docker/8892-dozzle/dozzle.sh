docker run -d --name=dozzle \
-p 8892:8080 \
-v /var/run/docker.sock:/var/run/docker.sock \
--detach \
--restart always \
amir20/dozzle:latest