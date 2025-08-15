mkdir -p ./docker
sudo chmod 777 ./docker/* -R
sudo chown ibrahim:ibrahim ./* -R

#

#
user: "${UID}:${GID}"
docker compose up -d

head -c32 /dev/urandom | base64

# https://mariushosting.com/docker/