provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "instance_1" {
  ami           = "ami-09cd747c78a9add63"
  instance_type = "t2.small"
  key_name      = "dschool"
  vpc_security_group_ids = ["sg-0727ee3d6745a3427"]

  tags = {
    Name = "jenkins-instance-1"
  }
}

resource "aws_instance" "instance_2" {
  ami           = "ami-09cd747c78a9add63"
  instance_type = "t2.small"
  key_name      = "dschool"
  vpc_security_group_ids = ["sg-0727ee3d6745a3427"]

  tags = {
    Name = "jenkins-instance-2"
  }
}

output "instance_1_ip" {
  value = aws_instance.instance_1.public_ip
}

output "instance_2_ip" {
  value = aws_instance.instance_2.public_ip
}
