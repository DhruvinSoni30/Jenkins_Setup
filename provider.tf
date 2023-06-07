# configure aws provider
provider "aws" {
  region  = var.region
  profile = "dhsoni"
}

# configure backend
terraform {
  backend "s3" {
    bucket         = "jenkins-dhsoni-terraform"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    profile        = "dhsoni"
    dynamodb_table = "jenkins-state-lock-dynamodb"
  }
}
