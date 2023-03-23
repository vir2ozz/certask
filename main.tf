provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "jenkins_agent" {
  ami           = "ami-09cd747c78a9add63"
  instance_type = "t2.small"

  key_name        = "dschool"
  security_groups = ["launch-wizard-2"]

  tags = {
    Name = "jenkins_agent"
  }
}

resource "aws_instance" "docker_host" {
  ami           = "ami-09cd747c78a9add63"
  instance_type = "t2.small"

  key_name        = "dschool"
  security_groups = ["launch-wizard-2"]

  tags = {
    Name = "docker_host"
  }
}

output "jenkins_agent_public_ip" {
  value = aws_instance.jenkins_agent.public_ip
}

output "docker_host_public_ip" {
  value = aws_instance.docker_host.public_ip
}
