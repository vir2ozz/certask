provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "instance1" {
  ami           = "ami-09cd747c78a9add63"
  instance_type = "t2.small"

  key_name          = "dschool"
  security_group_id = "sg-0727ee3d6745a3427"

  tags = {
    Name = "Instance1"
  }
}

resource "aws_instance" "instance2" {
  ami           = "ami-09cd747c78a9add63"
  instance_type = "t2.small"

  key_name          = "dschool"
  security_group_id = "sg-0727ee3d6745a3427"

  tags = {
    Name = "Instance2"
  }
}

output "instance1_public_ip" {
  value = aws_instance.instance1.public_ip
}

output "instance2_public_ip" {
  value = aws_instance.instance2.public_ip
}
