docker run -d \
    --name=watchtower \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /etc/localtime:/etc/localtime:ro \
    --restart=always \
    containrrr/watchtower --cleanup --interval 28800

# 28800 = 8 Hrs
# 3660 = 1 Hr
# --rolling-restart

# docs
# https://containrrr.dev/watchtower/arguments/

#run once
# docker run --rm \
#     --name=watchtower \
#     -v /var/run/docker.sock:/var/run/docker.sock \
#     containrrr/watchtower \
#     --run-once

# docker run -d \
#   --name watchtower \
#   -v /var/run/docker.sock:/var/run/docker.sock \
#   -e WATCHTOWER_NOTIFICATIONS=email \
#   -e WATCHTOWER_NOTIFICATION_EMAIL_FROM=fromaddress@gmail.com \
#   -e WATCHTOWER_NOTIFICATION_EMAIL_TO=toaddress@gmail.com \
#   -e WATCHTOWER_NOTIFICATION_EMAIL_SERVER=smtp.gmail.com \
#   -e WATCHTOWER_NOTIFICATION_EMAIL_SERVER_PORT=587 \
#   -e WATCHTOWER_NOTIFICATION_EMAIL_SERVER_USER=fromaddress@gmail.com \
#   -e WATCHTOWER_NOTIFICATION_EMAIL_SERVER_PASSWORD=app_password \
#   -e WATCHTOWER_NOTIFICATION_EMAIL_DELAY=2 \
# --restart=always \
#   containrrr/watchtower