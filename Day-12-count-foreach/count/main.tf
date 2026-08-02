resource "aws_instance" "name" {
  ami = "ami-0fd6b4bfb40773c2d"
    instance_type = "t3.micro"
    count = length(var.tags)
    tags = {
        Name = var.tags[count.index]
    }
}