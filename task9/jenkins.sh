#!/bin/bash
sudo mkdir ./Jenkins
cd ./Jenkins
# ----Plugins---------
sudo echo "chucknorris
git
workflow-multibranch
telegram-notifications
github
github-branch-source" > plugins.txt
# -------------
sudo echo "jenkins:
  securityRealm:
    local:
      allowsSignup: false
      users:
       - id: admin
         password: admin
  authorizationStrategy:
    globalMatrix:
      permissions:
        - "Overall/Administer:admin"
        - "Overall/Read:authenticated"
  remotingSecurity:
    enabled: true
security:
  queueItemAuthenticator:
    authenticators:
    - global:
        strategy: triggeringUsersAuthorizationStrategy
unclassified:
  location:
    url: http://server_ip:8080/" > casc.yaml
# -----Dockerfile--------
sudo echo "FROM jenkins/jenkins:latest
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt
COPY casc.yaml /var/jenkins_home/casc.yaml" > Dockerfile
# -----Docker--------
sudo apt-get update
sudo apt-get install -y cloud-utils apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce
# add current user to docker group so there is no need to use sudo when running docker
sudo usermod -aG docker $(whoami)

sudo docker build -t jenkins .

sudo docker run --name myjenkins -d -p 8080:8080 jenkins