docker run -d --name=doku \
-p 9092:9090 \
-v /var/run/docker.sock:/var/run/docker.sock:ro \
-v /:/hostroot:ro \
--restart always \
amerkurev/doku

# https://mariushosting.com/how-to-install-doku-on-your-synology-nas/

#Doku is a simple, lightweight web-based application that allows you to monitor Docker disk usage in a user-friendly manner. The Doku displays the amount of disk space used by the Docker daemon, splits by images, containers, volumes, and builder cache. Doku is a great alternative to Glances. 