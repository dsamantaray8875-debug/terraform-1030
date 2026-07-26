resource "aws_instance" "name" {
    ami = "ami-0fd6b4bfb40773c2d"
    instance_type = "t3.micro"
    user_data = file("userdata.sh")
    tags = {
        Name= "dev"
    }
  
}