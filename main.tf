provider "aws" {
  region = "us-east-1"
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

resource "tls_private_key" "app_instance" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "null_resource" "copy_public_key_to_java_builder" {
  depends_on = [aws_instance.java_builder, aws_instance.app_instance]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/dschool.pem")
    host        = aws_instance.java_builder.public_ip
  }

  provisioner "file" {
    content     = tls_private_key.app_instance.public_key_openssh
    destination = "/tmp/app_instance.pub"
  }

  provisioner "remote-exec" {
    inline = [
      "cat /tmp/app_instance.pub >> /home/ubuntu/.ssh/authorized_keys",
    ]
  }
}

resource "null_resource" "copy_public_key_to_app_instance" {
  depends_on = [aws_instance.java_builder, aws_instance.app_instance]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/dschool.pem")
    host        = aws_instance.app_instance.public_ip
  }

  provisioner "file" {
    content     = tls_private_key.app_instance.public_key_openssh
    destination = "/tmp/java_builder.pub"
  }

  provisioner "remote-exec" {
    inline = [
      "cat /tmp/java_builder.pub >> /home/ubuntu/.ssh/authorized_keys",
    ]
  }
}

output "app_instance_private_key" {
  value     = tls_private_key.app_instance.private_key_pem
  sensitive = true
}
