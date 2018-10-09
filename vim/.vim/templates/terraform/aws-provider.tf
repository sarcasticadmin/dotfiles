provider "aws" {
  region = "${var.region}"
}

terraform {
  required_version = "= 0.11.7"

  backend "s3" {
    bucket = "secure-bucket"
    key    = "terraform/default.tfstate"
    region = "us-east-1"
  }
}
