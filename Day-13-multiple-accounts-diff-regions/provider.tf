provider "aws" {
    profile = "dev"
    alias   = "dev-account"
  region  = "us-east-1"
}

provider "aws" {
    profile = "test"
    alias   = "test-account"
  region  = "us-west-2"
  
}