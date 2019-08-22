provider "aws" {
    region = "us-east-2"
    access_key = "${var.phariram_ak}"
    secret_key = "${var.phariram_sk}"
}

terraform {
  backend "s3" {
    bucket = "statefile-versioning"
    key    = "global/s3/terraform.tfstate"
    region = "us-east-2"
    access_key = "access_key"
    secret_key = "secret_key"
  }
}