mkdir -p ./docker
#sudo chmod 777 ./docker/* -R
#sudo chown ibrahim:ibrahim ./* -R

#

docker run -d \
-p 3004:8081 \
--name nexus \
--restart always \
-v ./docker/nexus-data:/nexus-data \
sonatype/nexus3:latest

#-e INSTALL4J_ADD_VM_PARAMS="-Xms2703m -Xmx2703m -XX:MaxDirectMemorySize=2703m -Djava.util.prefs.userRoot=./docker/java" \
#
#user: "${UID}:${GID}"
#docker compose up -d

head -c32 /dev/urandom | base64

# https://mariushosting.com/docker/