provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "instance1" {
  ami           = "ami-09cd747c78a9add63"
  instance_type = "t2.small"
  key_name      = "dschool"
  vpc_security_group_ids = ["sg-0727ee3d6745a3427"]

  tags = {
    Name = "instance1"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y openjdk-11-jdk
              useradd -m -s /bin/bash jenkins
              echo "jenkins:jenkins" | chpasswd
              EOF
}

resource "aws_instance" "instance2" {
  ami           = "ami-09cd747c78a9add63"
  instance_type = "t2.small"
  key_name      = "dschool"
  vpc_security_group_ids = ["sg-0727ee3d6745a3427"]

  tags = {
    Name = "instance2"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y openjdk-11-jdk
              useradd -m -s /bin/bash jenkins
              echo "jenkins:jenkins" | chpasswd
              EOF
}
