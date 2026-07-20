resource "aws_instance" "name" {
  ami = "ami-068b5bc67e48209c1"
    instance_type = "t3.micro"
    tags = {
        Name = "dev"
    }
}