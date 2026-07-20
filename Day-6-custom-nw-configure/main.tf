resource "aws_vpc" "dev_vpc" {
 cidr_block = "10.0.0.0/16"
    tags = {
        Name = "dev"
    }
}

resource "aws_subnet" "dev_subnet" {
    vpc_id = aws_vpc.dev_vpc.id
    cidr_block = "10.0.1.0/24"
    tags = {
        Name = "dev-subnet"
    }
    }

    resource "aws_internet_gateway" "dev_igw" {
        vpc_id = aws_vpc.dev_vpc.id
        tags = {
            Name = "dev-igw"
        }
    }

    resource "aws_route_table" "dev_route_table" {
        vpc_id = aws_vpc.dev_vpc.id
        tags = {
            Name = "dev-route-table"
        }
        route {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_internet_gateway.dev_igw.id
        }
    }

    resource "aws_route_table_association" "dev_route_table_association" {
        subnet_id = aws_subnet.dev_subnet.id
        route_table_id = aws_route_table.dev_route_table.id
    }

    resource "aws_security_group" "dev_sg" {
        name        = "dev-security-group"
        description = "Allow SSH and HTTP"
        vpc_id      = aws_vpc.dev_vpc.id

        ingress {
            from_port   = 22
            to_port     = 22
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

resource "aws_instance" "dev_instance"{
  ami           = "ami-0fd6b4bfb40773c2d"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.dev_subnet.id
  vpc_security_group_ids = [aws_security_group.dev_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "dev-instance"
  }
  
}