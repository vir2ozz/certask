provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "instance1" {
  ami           = "ami-09cd747c78a9add63"
  instance_type = "t2.small"

  key_name = "dschool"
  security_groups = ["launch-wizard-2"]

  tags = {
    Name = "instance1"
  }
}

resource "aws_instance" "instance2" {
  ami           = "ami-09cd747c78a9add63"
  instance_type = "t2.small"

  key_name = "dschool"
  security_groups = ["launch-wizard-2"]

  tags = {
    Name = "instance2"
  }
}

output "instance1_ip" {
  value = aws_instance.instance1.public_ip
}

output "instance2_ip" {
  value = aws_instance.instance2.public_ip
}
