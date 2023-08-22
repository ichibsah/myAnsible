#FROM jenkins/agent:alpine-jdk11
FROM jenkins/agent:latest-alpine-jdk11
USER root
RUN apk add python3
#RUN apk add python3-apt
RUN apk add py3-pip
RUN apk add ansible
RUN apk add apt
RUN pip install ansible
RUN python3 -m pip install --upgrade pip
RUN pip install --upgrade pip
USER jenkins
CMD [ "/bin/bash" ]