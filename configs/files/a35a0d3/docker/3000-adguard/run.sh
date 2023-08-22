mkdir -p ./docker
sudo chmod 777 ./docker/* -R
sudo chown ibrahim:ibrahim ./* -R

#
docker run -d --name=adguard \
-e TZ=Europe/Bucharest \
-v ./docker/adguard/config:/opt/adguardhome/conf \
-v ./docker/adguard/data:/opt/adguardhome/work \
-p 3000:3000 \
#-p 853:853 \
#-p 44:3000 \
--net=host \
--restart always \
adguard/adguardhome
#
#--net=host \
#user: "${UID}:${GID}"
#docker compose up -d


# https://mariushosting.com/docker/