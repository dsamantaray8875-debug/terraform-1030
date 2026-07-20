resource "aws_instance" "name" {
  ami = "ami-0fd6b4bfb40773c2d"
instance_type = "t3.micro"
tags = {
  Name= "server-1"
}


}

resource "aws_s3_bucket" "name" {
    bucket = "imp-dev-nit"
}


resource "aws_s3_bucket_versioning" "example_versioning" {
    bucket = aws_s3_bucket.name.id
    versioning_configuration {
        status = "Enabled"
    }
}