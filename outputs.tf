output "java_builder_public_ip" {
  value = aws_instance.java_builder.public_ip
}

output "app_instance_public_ip" {
  value = aws_instance.app_instance.public_ip
}
