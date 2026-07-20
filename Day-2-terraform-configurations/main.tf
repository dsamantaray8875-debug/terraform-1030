resource "aws_vpc" "dev" {
    cidr_block = var.cidr_block
    tags = {
        Name = var.tag
        

    }
  
}

resource "aws_vpc" "test" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "my-vpc"
    }
  
}


resource "aws_subnet" "dev" {
    vpc_id = aws_vpc.dev.id
    cidr_block = "10.0.1.0/24"
    tags = {
        Name = "my-subnet"
    }
}