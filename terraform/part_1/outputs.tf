output "app_url" {
  description = "Access your application here"
  value       = "http://${aws_instance.app_server.public_ip}:${var.frontend_port}"
}

output "ssh_command" {
  description = "Command to SSH into the instance"
  value       = "ssh -i ${var.key_name}.pem ubuntu@${aws_instance.app_server.public_ip}"
}