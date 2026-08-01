#!/bin/bash

yum update -y

yum install docker -y

systemctl enable docker

systemctl start docker

echo "Redis Endpoint: ${redis_host}" > /home/ec2-user/redis.txt

echo "Redis Port: ${redis_port}" >> /home/ec2-user/redis.txt