resource "aws_vpc" "name" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "dev"
  }

}
resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "my-igw"
  }
}

resource "aws_route_table" "name" {
  vpc_id = aws_vpc.name.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.name.id
  }
}
resource "aws_route_table_association" "subnet1" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.name.id
}

resource "aws_route_table_association" "subnet2" {
  subnet_id      = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.name.id
}


resource "aws_subnet" "subnet-1" {
  vpc_id                  = aws_vpc.name.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-subnet"
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id                  = aws_vpc.name.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-subnet-2"
  }
}

resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "allow ssh and http traffic"
  vpc_id      = aws_vpc.name.id

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
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict this in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "my_subnet_group" {
  name       = "my-subnet-group"
  subnet_ids = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]

}

resource "aws_db_instance" "name" {
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  identifier              = "my-db-instance"
  username                = "admin"
  password                = "Cloud123"
  parameter_group_name    = "default.mysql8.0"
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.my_security_group.id]
  db_subnet_group_name    = aws_db_subnet_group.my_subnet_group.name
  publicly_accessible     = true
  maintenance_window      = "mon:00:00-mon:03:00"
  backup_retention_period = 1

}


resource "aws_db_instance" "replica" {
  identifier             = "my-db-replica"
  instance_class         = "db.t3.micro"
  publicly_accessible    = true
  replicate_source_db    = aws_db_instance.name.arn
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  db_subnet_group_name   = aws_db_subnet_group.my_subnet_group.name
  skip_final_snapshot    = true
}
