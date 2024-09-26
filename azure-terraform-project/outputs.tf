output "jumpbox_public_ip" {
  description = "The public IP address of the Jumpbox."
  value       = azurerm_public_ip.jumpbox_ip.ip_address
}

output "jumpbox_private_ip" {
  description = "The private IP address of the Jumpbox."
  value       = azurerm_network_interface.nic[0].private_ip_address
}

output "server_private_ip" {
  description = "The private IP address of the Kubernetes server."
  value       = azurerm_network_interface.nic[1].private_ip_address
}

output "node_0_private_ip" {
  description = "The private IP address of Kubernetes node 0."
  value       = azurerm_network_interface.nic[2].private_ip_address
}

output "node_1_private_ip" {
  description = "The private IP address of Kubernetes node 1."
  value       = azurerm_network_interface.nic[3].private_ip_address
}
