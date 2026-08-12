output "build_host_public_ip" {
  description = "Public address of the build host."
  value       = aws_instance.build.public_ip
}

output "stage_host_public_ip" {
  description = "Public address of the staging host."
  value       = aws_instance.stage.public_ip
}

output "app_url" {
  description = "Where the deployed application answers once the pipeline finishes."
  value       = "http://${aws_instance.stage.public_ip}:${var.app_port}/"
}

output "ssh_user" {
  description = "Login user for the chosen AMI, consumed by the Ansible inventory step."
  value       = "ubuntu"
}
