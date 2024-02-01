# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
#
env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2=agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    ssh-add
    ssh-add ~/.ssh/id_rsa
    ssh-add ~/.ssh/ibrahim@4a999ff.key
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    ssh-add
    ssh-add ~/.ssh/id_rsa
    ssh-add ~/.ssh/ibrahim@4a999ff.key
fi

unset env
#
#eval "$(ssh-agent -s)"
#ssh-add ~/.ssh/id_rsa
ssh-add ~/.ssh/id_rsa
ssh-add ~/.ssh/ibrahim@4a999ff.key 
#ssh-add -L
#
git config --global user.name $USER
git config --global user.email $USER@$HOSTNAME
git config --global core.editor nano
git config --global init.defaultBranch main
#git branch -m <name> # rename brunch
#
alias apv='ansible-playbook --vault-id ~/.ssh/.jenkins-vault.pw'
#alias ansible-playbook='. ./environment.sh && ansible-playbook'
alias azlogin='az login --allow-no-subscriptions --use-device-code'
alias a=alias d=ls ds="ls -al" drt="ls -lart" g="grep -i --color=yes" gc="grep --color=yes" 
alias e=echo l=less t="type -a" ..="cd .." r="su -m root" 
alias md=mkdir rd=rmdir dfh="df -h" ll="ls -l" la="ls -la"
# ******************
alias gpom="git push -u origin master"
alias grv="git remote -v"
alias grao="git remote add origin $1"
alias gcbr="git clone -b <branch> <remote_repo>"
alias gcb="git checkout -b $1 &&  git push --set-upstream origin $1" # git create new branch and switch to it
#alias gcb="git checkout -b $1" # git create new branch and switch to it
alias gsb="git checkout $1" # git switch to desired branch
alias gl1="git log --oneline"
alias grh="git reset --hard" 
# ******************
alias dmesg="dmesg -w -H"
alias tsyslog="tail -f /var/log/syslog"
alias tauth="tail -f /var/log/auth.log"
alias tmylog="tail -f /root/logs/mylog-$(date +%F)"
alias tmyansible="tail -f ~/logs/myansible-$(date +%F)"
alias cmylog="cat /root/logs/mylog* | grep -i down"
alias myrmlint="rmlint -D -g -p -S pOma -s 7M ."
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
alias venvmk='virtualenv -p python3 .venv && source ./.venv/bin/activate'
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



#
#kubectl aliases
[ -f ~/opt/kubectx/.kubectl_aliases ] && source \
<(cat ~/opt/kubectx/.kubectl_aliases | sed -r 's/(kubectl.*) --watch/watch \1/g')

function kubectl() { echo "+ kubectl $@">&2; command kubectl $@; }
#
export KUBECTX_CURRENT_FGCOLOR=$(tput setaf 6) # blue text
export KUBECTX_CURRENT_BGCOLOR=$(tput setab 7) # white background
#
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export PATH=/sbin:/usr/sbin:/usr/local/bin:$PATH
export PATH=/home/isawadogo/opt/kubectx:$PATH
export PATH=$PATH:$HOME/.local/bin:$HOME/bin:/snap/fluxctl/162/bin
export EDITOR=nano
#
#echo "type your AZURE_PASSWORD:"
#read -s AZURE_PASSWORD
#

# ssh-keygen -t rsa -b 2048 -C "email" -f ~/.ssh/name.first_2048bit_id_rsa
