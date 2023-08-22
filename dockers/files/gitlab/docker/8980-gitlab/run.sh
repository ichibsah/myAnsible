#https://docs.gitlab.com/ee/install/docker.html
#
sudo chmod 777 ./docker/* -R
sudo chown ibrahim:ibrahim ./* -R
#
export GITLAB_HOME=./docker
#
docker pull gitlab/gitlab-ee:latest
#
docker run --detach \
  --hostname gitlab.skyline.lan \
  --publish 8943:443 \
  --publish 8980:80 \
  --publish 8922:22 \
  --name gitlab \
  --restart always \
  --volume ./docker/config:/etc/gitlab \
  --volume ./docker/logs:/var/log/gitlab \
  --volume ./docker/data:/var/opt/gitlab \
  --shm-size 256m \
  gitlab/gitlab-ee:latest
  #
docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password