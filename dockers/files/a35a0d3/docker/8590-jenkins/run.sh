sudo chmod 777 ./docker/* -R
sudo chown ibrahim:ibrahim ./* -R
#
docker network create jenkins
#
docker run -d \
 --name jenkins \
 --network jenkins \
 -p 8590:8080 \
 -p 50000:50000 \
 --env DOCKER_HOST=tcp://docker:2376 \
 --env DOCKER_CERT_PATH=/certs/client \
 --env DOCKER_TLS_VERIFY=1 \
 -v ./docker/jenkins_home:/var/jenkins_home \
 -v ./docker/certs:/certs/client:ro \
 --restart always \
 jenkins/jenkins:latest
#
docker run -d \
 --name socat \
 --restart=always \
 -p 127.0.0.1:2376:2375 \
 --network jenkins \
 -v /var/run/docker.sock:/var/run/docker.sock \
 alpine/socat \
 tcp-listen:2375,fork,reuseaddr \
 unix-connect:/var/run/docker.sock

docker inspect jenkins | grep IPAddress

# https://mariushosting.com/docker/



# --network jenkins --env DOCKER_HOST=tcp://docker:2376 \
#   --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 \
#   --publish 8080:8080 --publish 50000:50000 \
#   --volume jenkins-data:/var/jenkins_home \
#   --volume jenkins-docker-certs:/certs/client:ro \