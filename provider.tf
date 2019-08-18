provider "aws" {
    region = "us-east-2"
    access_key = "${var.phariram_ak}"
    secret_key = "${var.phariram_sk}"
}
