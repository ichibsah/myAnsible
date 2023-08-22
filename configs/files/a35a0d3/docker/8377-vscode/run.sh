mkdir -p ./docker
sudo chmod 777 ./docker/* -R
sudo chown ibrahim:ibrahim ./* -R

#
docker run -d --name=codeserver \
-p 8377:8443 \
-e PUID=1026 \
-e PGID=100 \
-e TZ=Europe/Berlin \
-e PASSWORD={{localhost_become_pass}} \
-e PROXY_DOMAIN=vscode.sawadogo.xyz \
-e SUDO_PASSWORD={{localhost_become_pass}} \
-v ./docker/codeserver:/config \
--restart always \
ghcr.io/linuxserver/code-server
#
#user: "${UID}:${GID}"
#docker compose up -d


# https://mariushosting.com/docker/