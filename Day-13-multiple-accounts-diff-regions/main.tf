resource "aws_s3_bucket" "dev-bucket" {
    bucket = "ujdsnjnjdm"
    provider = aws.dev-account
  
}

resource "aws_s3_bucket" "test-bucket" {
    bucket = "usjkskkasnjnskand"
    provider = aws.test-account
  
}