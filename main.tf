provider "aws" {
  region  = "us-east-1"
  profile = "devops"
}

resource "aws_instance" "app" {
  ami           = "ami-09cd747c78a9add63"
  instance_type = "t2.small"
  key_name      = "dschool"

  vpc_security_group_ids = ["sg-0727ee3d6745a3427"]

  tags = {
    Name = "jenkins-app-instance"
  }
}
