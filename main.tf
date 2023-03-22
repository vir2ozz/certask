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

resource "null_resource" "copy_public_key_to_java_builder" {
  provisioner "file" {
    content     = file("/home/ubuntu/.ssh/id_rsa.pub")
    destination = "/home/ubuntu/.ssh/id_rsa.pub"
  }

  provisioner "remote-exec" {
    inline = [
      "cat /home/ubuntu/.ssh/id_rsa.pub >> /home/ubuntu/.ssh/authorized_keys
      "chmod 600 /home/ubuntu/.ssh/authorized_keys",
      "rm /home/ubuntu/.ssh/id_rsa.pub"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/home/ubuntu/.ssh/dschool.pem")
      host        = aws_instance.java_builder.public_ip
    }
  }

  depends_on = [aws_instance.java_builder]
}

resource "null_resource" "copy_public_key_to_app_instance" {
  provisioner "file" {
    content     = file("/home/ubuntu/.ssh/id_rsa.pub")
    destination = "/home/ubuntu/.ssh/id_rsa.pub"
  }

  provisioner "remote-exec" {
    inline = [
      "cat /home/ubuntu/.ssh/id_rsa.pub >> /home/ubuntu/.ssh/authorized_keys",
      "chmod 600 /home/ubuntu/.ssh/authorized_keys",
      "rm /home/ubuntu/.ssh/id_rsa.pub"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/home/ubuntu/.ssh/dschool.pem")
      host        = aws_instance.app_instance.public_ip
    }
  }

  depends_on = [aws_instance.app_instance]
}
