#!/bin/bash
#
# Install unzip and mariadb
yum update -y
yum install unzip mariadb -y
#
# ECS config
echo "ECS_CLUSTER=example-stg-ecs-cluster" >> /etc/ecs/ecs.config
start ecs
#
# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscli-exe-linux-x86_64.zip"
unzip awscli-exe-linux-x86_64.zip
./aws/install
export PATH=$PATH:/usr/local/bin/aws
rm awscli-exe-linux-x86_64.zip
rm -r ~/aws/
#
# Fix locale error
echo 'LANG=en_US.utf-8' >> /etc/environment
echo 'LC_ALL=en_US.utf-8' >> /etc/environment
