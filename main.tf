provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "stage" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = "stage"
  }
}
