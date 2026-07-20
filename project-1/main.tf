resource "aws_iam_user" "user" {
  name = var.user_name
}

resource "aws_iam_group" "group" {
  name = "Developers"
}

resource "aws_iam_group_membership" "membership" {
  name = "developer-members"

  users = [
    aws_iam_user.user.name
  ]

  group = aws_iam_group.group.name
}

resource "aws_iam_policy" "s3_policy" {

  name = "S3ReadOnly"

  policy = jsonencode({

    Version="2012-10-17"

    Statement=[

      {

      Effect="Allow"

      Action=[

      "s3:ListBucket",

      "s3:GetObject"

      ]

      Resource="*"

      }

    ]
  })
}

resource "aws_iam_group_policy_attachment" "attach" {

  group = aws_iam_group.group.name

  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_iam_role" "ec2_role" {

name = "EC2Role"

assume_role_policy = jsonencode({

Version="2012-10-17"

Statement=[

{

Effect="Allow"

Principal={

Service="ec2.amazonaws.com"

}

Action="sts:AssumeRole"

}

]

})
}

resource "aws_vpc" "main" {

cidr_block="10.0.0.0/16"

enable_dns_support=true

enable_dns_hostnames=true

tags={

Name="Terraform-VPC"

}
}

resource "aws_internet_gateway" "igw" {

vpc_id=aws_vpc.main.id
}

resource "aws_subnet" "public1" {

vpc_id=aws_vpc.main.id

cidr_block="10.0.1.0/24"

availability_zone="us-west-2a"

map_public_ip_on_launch=true
}

resource "aws_subnet" "public2" {

vpc_id=aws_vpc.main.id

cidr_block="10.0.2.0/24"

availability_zone="us-west-2b"

map_public_ip_on_launch=true
}

resource "aws_subnet" "private1" {

vpc_id=aws_vpc.main.id

cidr_block="10.0.3.0/24"

availability_zone="us-west-2a"
}

resource "aws_subnet" "private2" {

vpc_id=aws_vpc.main.id

cidr_block="10.0.4.0/24"

availability_zone="us-west-2b"
}


resource "aws_security_group" "web" {

  name = "web-sg"

  vpc_id = aws_vpc.main.id


  ingress {

    from_port = 80

    to_port = 80

    protocol = "tcp"

    security_groups = [
      aws_security_group.alb.id
    ]

  }


  ingress {

    from_port = 22

    to_port = 22

    protocol = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]

  }


  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]

  }

}


resource "aws_instance" "web" {


  ami = "ami-0fd6b4bfb40773c2d"


  instance_type = "t3.micro"


  subnet_id = aws_subnet.public1.id


  vpc_security_group_ids = [
    aws_security_group.web.id
  ]


  tags = {

    Name = "web-server"

  }

}

resource "aws_lb_target_group" "tg" {

name="alb-target"

port=80

protocol="HTTP"

vpc_id=aws_vpc.main.id
health_check {

path="/"

port="80"

protocol="HTTP"

matcher="200"




}
}


resource "aws_lb_target_group_attachment" "web" {


  target_group_arn = aws_lb_target_group.tg.arn


  target_id = aws_instance.web.id


  port = 80

}

resource "aws_eip" "nat" {

domain="vpc"
}

resource "aws_nat_gateway" "nat" {

allocation_id=aws_eip.nat.id

subnet_id=aws_subnet.public1.id
}

resource "aws_route_table" "public" {

vpc_id=aws_vpc.main.id

route{

cidr_block="0.0.0.0/0"

gateway_id=aws_internet_gateway.igw.id

}
}

resource "aws_route_table_association" "pub1" {

subnet_id=aws_subnet.public1.id

route_table_id=aws_route_table.public.id
}


resource "aws_route_table_association" "pub2" {

  subnet_id = aws_subnet.public2.id

  route_table_id = aws_route_table.public.id

}


resource "aws_route_table" "private" {

vpc_id=aws_vpc.main.id

route{

cidr_block="0.0.0.0/0"

nat_gateway_id=aws_nat_gateway.nat.id

}
}


resource "aws_db_subnet_group" "private" {

name = "private-subnets"

subnet_ids = [
  aws_subnet.private1.id,
  aws_subnet.private2.id
]

tags = {
  Name = "Private DB Subnet Group"
}

}

resource "aws_route_table_association" "private1" {

  subnet_id = aws_subnet.private1.id

  route_table_id = aws_route_table.private.id
}


resource "aws_route_table_association" "private2" {

  subnet_id = aws_subnet.private2.id

  route_table_id = aws_route_table.private.id
}


module "rds" {
  source = "./modules/rds"

  db_name      = "mydb"
  username     = "admin"
  password     = "Deepak12345"
  subnet_group = aws_db_subnet_group.private.name
}

resource "aws_security_group" "alb" {

name="alb-sg"

vpc_id=aws_vpc.main.id

ingress{

from_port=80

to_port=80

protocol="tcp"

cidr_blocks=["0.0.0.0/0"]

}

egress{

from_port=0

to_port=0

protocol="-1"

cidr_blocks=["0.0.0.0/0"]

}
}



resource "aws_lb" "alb" {

name="terraform-alb"

internal=false

load_balancer_type="application"

security_groups=[aws_security_group.alb.id]

subnets=[

aws_subnet.public1.id,

aws_subnet.public2.id

]
}

resource "aws_lb_listener" "listener" {

load_balancer_arn=aws_lb.alb.arn

port=80

protocol="HTTP"

default_action{

type="forward"

target_group_arn=aws_lb_target_group.tg.arn

}
}






