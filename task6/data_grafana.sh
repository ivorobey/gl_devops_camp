#!/bin/bash

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

sudo docker pull grafana/grafana

sudo docker run -d --name=grafana -p 3000:3000 grafana/grafana


#Another way to install Grafana

# sudo apt-get update -y
# apt-get upgrade -y
# sudo apt-get install gnupg2 curl wget git software-properties-common -y
# sudo curl https://packages.grafana.com/gpg.key | apt-key add -
# add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
# sudo apt-get update -y
# sudo apt-get install grafana -y
# sudo systemctl start grafana-server
# sudo systemctl enable grafana-server
