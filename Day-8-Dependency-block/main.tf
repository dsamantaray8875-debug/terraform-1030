resource "aws_vpc" "name" {
    cidr_block           = "10.0.0.0/16"
  
}

resource aws_s3_bucket "my_bucket" {
  bucket = "my-terraform-abcdsbucket"
  depends_on = [ aws_vpc.name ]
}