output "jumpbox_public_ip" {
  description = "Public IP of the jumpbox for SSH access."
  value       = aws_instance.jumpbox.public_ip
}

output "server_private_ip" {
  description = "Private IP of the Kubernetes server."
  value       = aws_instance.server.private_ip
}

output "node_0_private_ip" {
  description = "Private IP of Kubernetes node 0."
  value       = aws_instance.node_0.private_ip
}

output "node_1_private_ip" {
  description = "Private IP of Kubernetes node 1."
  value       = aws_instance.node_1.private_ip
}
