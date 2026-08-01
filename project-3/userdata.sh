#!/bin/bash

yum update -y

yum install -y mysql

echo "Database Endpoint: ${db_host}" > /home/ec2-user/db-info.txt
echo "Database Port: ${db_port}" >> /home/ec2-user/db-info.txt