resource "aws_instance" "name" {
  ami = "ami-0fd6b4bfb40773c2d1"
instance_type = "t3.micro"
tags = {
  Name= "server-1"
}

lifecycle {
    create_before_destroy = true
  
}


#lifecycle {
  #ignore_changes = [tags]
#}

#lifecycle {
 # prevent_destroy = true
 
#}

}