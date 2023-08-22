cd /opt/sandbox/meryem
sudo chmod 777 ./docker/* -R
sudo chown ibrahim:ibrahim ./* -R
#
docker rm -f meryem
cd /opt/sandbox/meryem
docker build -t meryem:latest .
cd /opt/docker/8090-meryem
docker run -it -d \
    -p 8090:8000 \
    --name meryem \
    --restart always \
    meryem:latest
#     #-v ./docker/code:/code \

# git config pull.rebase false  # merge (the default strategy)
# #git config pull.rebase true   # rebase
# #git config pull.ff only       # fast-forward only