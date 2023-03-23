provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app_instance" {
  ami           = "ami-09cd747c78a9add63"
  instance_type = "t2.small"
  key_name      = "dschool"

  vpc_security_group_ids = [
    "sg-0727ee3d6745a3427",
  ]

  tags = {
    Name = "AppInstance"
  }
}

resource "aws_instance" "docker_instance" {
  ami           = "ami-09cd747c78a9add63"
  instance_type = "t2.small"
  key_name      = "dschool"

  vpc_security_group_ids = [
    "sg-0727ee3d6745a3427",
  ]

  tags = {
    Name = "DockerInstance"
  }
}

output "app_instance_public_ip" {
  value = aws_instance.app_instance.public_ip
}

output "docker_instance_public_ip" {
  value = aws_instance.docker_instance.public_ip
}
