provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "devops-student"
}

resource "aws_instance" "java_builder" {
  ami           = "ami-09cd747c78a9add63"
  instance_type = "t2.small"
  key_name      = "dschool"

  vpc_security_group_ids = ["sg-0727ee3d6745a3427"]

  tags = {
    Name = "java-builder"
  }
}

resource "aws_instance" "app_instance" {
  ami           = "ami-09cd747c78a9add63"
  instance_type = "t2.small"
  key_name      = "dschool"

  vpc_security_group_ids = ["sg-0727ee3d6745a3427"]

  tags = {
    Name = "app-instance"
  }
}
