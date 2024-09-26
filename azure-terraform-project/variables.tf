variable "location" {
  description = "The Azure region where resources will be created."
  default     = "East US"
}

variable "admin_username" {
  description = "Admin username for the virtual machines."
}

variable "admin_ssh_public_key" {
  description = "SSH public key for admin user authentication."
}

variable "public_ip" {
  description = "Public IP address for SSH access"
  type        = string
}
