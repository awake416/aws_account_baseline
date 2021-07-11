#! /bin/bash
sudo yum update -y
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo systemctl start httpd
sudo systemctl enable httpd

sudo yum install -y java-1.8.0-openjdk
sudo yum install -y aerobase-2.4.2.el7.x86_64.rpm aerobase-iam-2.4.2.el7.x86_64.rpm
