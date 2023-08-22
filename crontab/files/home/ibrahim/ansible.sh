#!/bin/bash
RED='\033[0;31m'
NOCOLOR='\033[0m'
FileName=myansible-`date +%F`
LOG=/home/ibrahim/logs/$FileName

mkdir -p /home/ibrahim/sandbox-ansible/ /home/ibrahim/logs

# Set the repository URL and branch
REPO_URL="https://github.com/ichibsah/ansible-for-devops.git"

BRANCH="master"

# Set the repository directory
REPO_DIR="/home/ibrahim/sandbox-ansible/ansible-for-devops"

# Check if the repository directory already exists
if [ -d "$REPO_DIR" ]; then
  # Go to the repository directory
  cd "$REPO_DIR"
  
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
    #echo "Pull successful"
    echo -e "`date` ${NOCOLOR} - Pull successful" >> $LOG
    pwd
    cd "$REPO_DIR"
    cd mySetupRoles
    pwd
    bash /home/ibrahim/sandbox-ansible/ansible-for-devops/mySetupRoles/md-shop.sh >> $LOG
  else
    # Print a message to confirm that there were no updates
    #echo "Already up to date - no need to start ansible"
    echo -e "`date` ${NOCOLOR} - Already up to date - no need to start ansible" >> $LOG
    pwd
    cd "$REPO_DIR"
    cd mySetupRoles
    pwd
    #bash /home/ibrahim/sandbox-ansible/ansible-for-devops/mySetupRoles/md-shop.sh >> $LOG # debug
  fi
else
  # Clone the repository if it doesn't exist
  git clone "$REPO_URL" "$REPO_DIR"
  
  # Print a message to confirm that the repository was cloned
  #echo "Repository cloned - starting first time ansible"
  echo -e "`date` ${NOCOLOR} - Repository cloned - starting first time ansible" >> $LOG
  pwd
  cd "$REPO_DIR"
  cd mySetupRoles
  pwd
  bash /home/ibrahim/sandbox-ansible/ansible-for-devops/mySetupRoles/md-shop.sh >> $LOG
fi

#/**************/




#mkdir -p /home/ibrahim/sandbox-ansible/
#cd /home/ibrahim/sandbox-ansible/
#git clone git@github.com:ichibsah/ansible-for-devops.git
#cd /home/ibrahim/sandbox-ansible/ansible-for-devops/
#bash ./md-shop.sh
#rm -rf /home/ibrahim/sandbox-ansible/