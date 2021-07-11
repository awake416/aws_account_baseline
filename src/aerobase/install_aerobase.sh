#! /bin/bash
sudo yum update -y

sudo yum install -y docker
sudo systemctl enable --now docker
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo yum install -y java-1.8.0-openjdk

