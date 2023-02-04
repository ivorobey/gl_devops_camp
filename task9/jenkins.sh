#!/bin/bash
sudo mkdir ./Jenkins
cd ./Jenkins
# -------------
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
# -------------
sudo echo "FROM jenkins/jenkins:latest
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt
COPY casc.yaml /var/jenkins_home/casc.yaml" > Dockerfile
# -------------
docker build -t jenkins:1.0 .
# -------------
docker run --name first-jenkins -d -p 8080:8080 jenkins:1.0