terraform {
  source = "../../modules/ec2"
}

inputs = {
  ami             = "ami-028ba4d4ccb4b7b72"   # Replace with your region's AMI if needed
  instance_type   = "t3.medium"
  instance_name   = "prod-server"
}