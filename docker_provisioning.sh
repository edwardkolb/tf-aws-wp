#!/bin/bash

sudo apt install
sudo apt install curl
curl -fsSL https://get.docker.com/ | sh
sudo systemctl start docker
sudo groupadd docker
sudo usermod -aG docker ubuntu

sudo apt-get update
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose -version