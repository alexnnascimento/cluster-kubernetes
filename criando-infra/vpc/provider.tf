#terraform {
#  required_version = "1.1.9"
#}
terraform {
  backend "s3" {
    bucket = "desmondlab-tfstate"
    key    = "tfstate-vpc"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "terraform-github"
}