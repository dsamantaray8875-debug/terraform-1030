resource "aws_security_group" "app_sg" {

  name = "application-sg"

  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "mysql" {

  source = "./modules/rds"

  vpc_id = var.vpc_id

  private_subnets = var.private_subnets

  db_username = var.db_username

  db_password = var.db_password

  app_sg = aws_security_group.app_sg.id
}

resource "aws_instance" "app_server" {

  ami = var.ami

  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.app_sg.id]
  subnet_id              = var.private_subnets[0]
  user_data = templatefile("${path.module}/userdata.sh", {
    db_host = module.mysql.db_endpoint
    db_port = module.mysql.db_port
  })

  tags = {
    Name = "ApplicationServer"
  }
}