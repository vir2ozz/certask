provider "aws" {
  region     = "us-east-1"
  access_key = "AKIA5M4V4GFC2YHRFZXO"
  secret_key = "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"
}

resource "aws_instance" "app_instance" {
  ami           = "ami-09cd747c78a9add63"
  instance_type = "t2.small"
  key_name      = "dschool"

  vpc_security_group_ids = ["sg-0727ee3d6745a3427"]

  tags = {
    Name = "certask-app-instance"
  }
}
