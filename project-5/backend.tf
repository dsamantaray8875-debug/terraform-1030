terraform {

  backend "s3" {

    bucket         = "deepak-terraform-state-2026"

    key            = "project-5/terraform.tfstate"

    region         = "us-east-2"

    dynamodb_table = "terraform-lock"

    encrypt        = true

  }

}