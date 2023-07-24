#!/bin/bash
# sudo yum update -y
# sudo yum install python -y 
# sudo amazon-linux-extras install ansible2
# sudo yum install docker -y
# sudo service docker start
sudo apt update -y
sudo apt-y install software-properties-common
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get install ansible -y 