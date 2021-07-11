#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
# This is just a test
echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html

sudo apt-get install -y openjdk-8-jdk
sudo apt-get install -y aerobase_2.4.2_xenial.deb aerobase-iam_2.4.2_xenial.deb
