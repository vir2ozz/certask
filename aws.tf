provider "aws" {
  access_key = "<your_access_key>"
  secret_key = "<your_secret_key>"
  region     = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  count         = 2

  tags = {
    Name = "ExampleInstance-${count.index + 1}"
  }

  provisioner "file" {
    source      = "docker-compose.yml"
    destination = "/home/ubuntu/docker-compose.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y docker.io",
      "sudo docker-compose up -d",
    ]
  }

  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("<path_to_your_private_key>")
    host = self.public_ip
  }
}
