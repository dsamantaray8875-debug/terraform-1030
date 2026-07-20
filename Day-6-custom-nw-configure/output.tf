output "publicip"{
  value = aws_instance.dev_instance.public_ip
 description = "Public IP of the instance" 
}

output "privateip"{
  value = aws_instance.dev_instance.private_ip
 description = "Private IP of the instance" 
}

output "instanceid"{
  value = aws_instance.dev_instance.id
 description = "Instance ID of the instance" 
}

output "az"{
  value = aws_instance.dev_instance.availability_zone
 description = "Availability Zone of the instance"
}

output "vpcid"{
  value = aws_vpc.dev_vpc.id
 description = "VPC ID of the instance" 
}