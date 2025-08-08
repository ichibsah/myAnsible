# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "$(dircolors)"
# alias ls='ls $LS_OPTIONS'
# alias ll='ls $LS_OPTIONS -l'
# alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
#
alias apv='ansible-playbook --vault-id ~/.ssh/.jenkins-vault.pw'
#alias ansible-playbook='. ./environment.sh && ansible-playbook'
alias azlogin='az login --allow-no-subscriptions --use-device-code'
alias a=alias d=ls ds="ls -al" drt="ls -lart" g="grep -i --color=yes" gc="grep --color=yes" 
alias e=echo l=less t="type -a" ..="cd .." r="su -m root" 
alias md=mkdir rd=rmdir dfh="df -h" ll="ls -lh" la="ls -lah"
# ******************
alias gpom="git push -u origin master"
alias grv="git remote -v"
alias grao="git remote add origin $1"
alias gcbr="git clone -b <branch> <remote_repo>"
alias gcb="git checkout -b $1 &&  git push --set-upstream origin $1" # git create new branch and switch to it
#alias gcb="git checkout -b $1" # git create new branch and switch to it
alias gsb="git checkout $1" # git switch to desired branch
alias gl1="git log --oneline"
alias grh="git reset --hard"  #git reset --hard origin/master
#
# ******************
alias dmesg="dmesg -w -H"
alias tsyslog="tail -f /var/log/syslog"
alias tauth="tail -f /var/log/auth.log"
alias tmylog="tail -f /root/logs/mylog-$(date +%F)"
alias tmyansible="tail -f ~/logs/myansible-$(date +%F)"
alias cmylog="cat /root/logs/mylog* | grep -i down"
alias myrmlint="rmlint -D -g -p -S pOma -s 7M ."
alias myrmlint2="nohup rmlint -D -g -p -S pOma -s 7M . > ~/disown/output-$(date +%F).log 2>&1 &"
alias myrmlint1="rmlint -pvgw -s 7M ."
alias def="find . -type d -empty -delete"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias docker-compose="docker compose"
alias restart="~/scripts/restart.sh"
alias ss="ss -altnp"
alias fs="ncdu"
alias ari='ansible-galaxy role init'
alias vulscan='nmap -sV --script vulscan'
alias rmv='rsync -avz --remove-source-files'
alias prune='docker volume prune && docker system prune -a && docker system prune -a --volumes && docker network prune && docker image prune -a && docker container prune && docker system prune -af'
alias update='sudo apt update && sudo apt upgrade -y && docker system prune -af && pip-review --auto && python3 -m pip install --upgrade pip ansible'
alias ift='sudo iftop -PFG -i eno1'
alias tig='tig'
alias copy='rsync -vrumpgtoU'
alias move='rsync -vrumpgtoU --del'
alias scs='systemctl status'
alias scr='systemctl restart'
alias devstat='nmcli dev status'
alias constat='nmcli con show'
alias venv='source ./.venv/bin/activate'
alias venvmk='python3 -m venv .venv || virtualenv -p python3 .venv && source ./.venv/bin/activate'
alias python='python3'
alias port='netstat -ltnp | grep $1'
alias djngprg='python3 -m pip install django && python3 -m pip install --upgrade pip && pip install djlint && django-admin startproject config . && python manage.py startapp website && python manage.py migrate && pip freeze > requirements.txt && python manage.py runserver 0.0.0.0:8000'
alias rserver='python manage.py runserver 0.0.0.0:8000'
alias llsl='ls -l `find . -maxdepth 1 -type l -print`' # list symlink files only
# ******************
alias apr='apropos'
alias z='ps aux | egrep "Z|defunct"' # zombie processes
alias diso="nohup $ > ~/disown/output-$(date +%F).log 2>&1 &"
# ******************
alias ver='uname -srm && cat /etc/*version && hostnamectl && cat /etc/issue && cat /etc/os-release && lsb_release -a'
# ******************
alias audit='aureport -au -i | more && aureport -au -i --success | more && aureport -au -i --failed | more && aureport -l --success --summary -i | more'
# ******************
alias pweb='python3 -m http.server'
# ******************
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export EDITOR=nano
#
git config --global user.name $USER
git config --global user.email $USER@$HOSTNAME
git config --global core.editor nano
git config --global init.defaultBranch main
git config --global pull.ff only
#git branch -m <name> # rename brunch