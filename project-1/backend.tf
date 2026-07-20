terraform {
  backend "s3" {
    bucket         = "deepak-terraform-state-2025"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}