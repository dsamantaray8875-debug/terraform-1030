resource "aws_security_group" "app_sg" {

  name   = "application-sg-redis"

  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "redis" {

  source = "./modules/redis"

  vpc_id = var.vpc_id

  private_subnets = var.private_subnets

  app_sg = aws_security_group.app_sg.id

}

resource "aws_instance" "app_server" {

  ami = var.ami

  instance_type = var.instance_type

  subnet_id = var.private_subnets[0]

  vpc_security_group_ids = [
    aws_security_group.app_sg.id
  ]

  user_data = templatefile("${path.module}/userdata.sh", {

    redis_host = module.redis.redis_endpoint

    redis_port = module.redis.redis_port

  })

  tags = {
    Name = "ApplicationServer"
  }
}