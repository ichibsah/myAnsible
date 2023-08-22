#touch $(pwd)/docker/npm/config.json
docker run -d --name=nginx_proxy_manager \
-p 8081:81 \
-p 80:80 \
-p 443:443 \
-e PUID=1000 \
-e PGID=1000 \
-e TZ=Europe/Berlin \
-v $(pwd)/docker/npm/config.json:/app/config/production.json:rw \
-v $(pwd)/docker/npm/data:/data \
-v $(pwd)/docker/npm/letsencrypt:/etc/letsencrypt \
--restart always \
jc21/nginx-proxy-manager



# admin@example.com and in the Password field type in changeme

# https://mariushosting.com/how-to-install-nginx-proxy-manager-on-your-synology-nas/