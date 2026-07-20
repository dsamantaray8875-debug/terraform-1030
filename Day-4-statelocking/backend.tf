terraform {
  backend "s3" {
    bucket = "state-bucketdeploy"
    key    = "terraform.tfstate"
    region = "eu-north-1"
    
  }
}