provider "aws" {
  region = "us-east-1"
  access_key = "AKIA5M4V4GFC47QOD6VK"
  secret_access_key = "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"
}

resource "aws_instance" "app" {
  ami           = "ami-09cd747c78a9add63"
  instance_type = "t2.small"
  key_name      = "jenkins-ec2-keypair"

  vpc_security_group_ids = [
    "sg-0727ee3d6745a3427",
  ]

  tags = {
    Name = "app-instance"
  }
}

output "app_instance_ip" {
  value = aws_instance.app.public_ip
}
