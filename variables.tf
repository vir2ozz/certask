variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Name prefix applied to every resource and used in tags."
  type        = string
  default     = "certask"
}

variable "instance_type" {
  description = "EC2 instance type for the build and staging hosts."
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "Name of an existing EC2 key pair used for SSH access."
  type        = string
}

variable "ssh_ingress_cidr" {
  description = "CIDR allowed to reach port 22. Deliberately has no default - scope it to the Jenkins agent, e.g. 203.0.113.10/32."
  type        = string

  validation {
    condition     = var.ssh_ingress_cidr != "0.0.0.0/0"
    error_message = "Refusing to open SSH to the whole internet. Scope ssh_ingress_cidr to a specific address."
  }
}

variable "app_ingress_cidr" {
  description = "CIDR allowed to reach the application on the app port."
  type        = string
  default     = "0.0.0.0/0"
}

variable "app_port" {
  description = "Port the application container listens on."
  type        = number
  default     = 8080
}

variable "vpc_cidr" {
  description = "CIDR block for the project VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.20.1.0/24"
}
