##docker rm -f meryem

##docker build -t meryem:latest .
#docker build -t meryem:latest -t meryem:v2.0 . 
#docker run -it -d -p 8090:80 -v /home/ibrahim/sandbox/meryem/logs:/var/log/nginx:rw --name meryem meryem 
#docker run -it -d -p 8090:80 --name meryem --restart always -v /home/ibrahim/sandbox/meryem/website:/www -v /home/ibrahim/sandbox/meryem/logs:/var/log/nginx:rw meryem:latest 
##docker run -it -d -p 8090:8000 --name meryem --restart always meryem:latest 
#docker run -it meryem 
#docker run -it node
#docker exec -it meryem sh
#/***********/
#!/bin/bash
RED='\033[0;31m'
NOCOLOR='\033[0m'
AppName=meryem
FileName=$AppName-`date +%F`
LOG=/home/ibrahim/logs/$FileName

mkdir -p /home/ibrahim/sandbox /home/ibrahim/logs

# Set the repository URL and branch
REPO_URL="https://github.com/ichibsah/$AppName.git"

BRANCH="main"

# Set the repository directory
WORK_DIR="/home/ibrahim/sandbox"
PWD_DIR="$WORK_DIR/$AppName"
REPO_DIR="$WORK_DIR/$AppName"
#mkdir -p $WORK_DIR/8090-$AppName

# Check if the repository directory already exists
if [ -d "$REPO_DIR" ]; then
  # Go to the repository directory
  cd "$PWD_DIR"
  
  # Check for any updates
  git fetch

  # Get the latest commit hash of the branch
  LATEST_COMMIT=$(git rev-parse origin/$BRANCH)

  # Get the current commit hash
  CURRENT_COMMIT=$(git rev-parse HEAD)

  # Compare the latest commit hash with the current commit hash
  if [ "$LATEST_COMMIT" != "$CURRENT_COMMIT" ]; then
    # Pull the latest changes
    git pull origin $BRANCH
    
    # Print a message to confirm that the pull was successful
    echo -e "`date` ${RED} - Pull successful" >> $LOG

    bash /opt/docker/8090-meryem/run.sh >> $LOG

  else
    # Print a message to confirm that there were no updates
    echo -e "`date` ${NOCOLOR} - Already up to date - no need to start $AppName" >> $LOG

  fi
else
  # Clone the repository if it doesn't exist
  git clone "$REPO_URL" "$PWD_DIR"
  
  # Print a message to confirm that the repository was cloned
  echo -e "`date` ${RED} - Repository cloned - starting first time $AppName" >> $LOG

  bash /opt/docker/8090-meryem/run.sh >> $LOG &
fi
#
cd "$PWD_DIR"
#git config pull.rebase false  # merge (the default strategy)
#git config pull.rebase true   # rebase
git config pull.ff only       # fast-forward only