variable "aws_region" {
  description = "The AWS region to create resources in."
  default     = "us-east-1"
}

variable "aws_availability_zone" {
  description = "The AWS availability zone to use."
  default     = "us-east-1a"
}

variable "allowed_ip" {
  description = "The IP address allowed to SSH into the instances."
  type        = string
}

variable "ami_id" {
  description = "The AMI ID for Debian 12 (bookworm) ARM64."
  type        = string
}

variable "public_key_path" {
  description = "Path to your public SSH key."
  type        = string
}

variable "instance_username" {
  description = "Username for EC2 instance SSH access."
  type        = string
  default     = "admin"
}

variable "user_data" {
  description = "The script to set password-based authentication on the instance."
  type        = string
}
