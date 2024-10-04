provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "kubernetes-vpc"
  }
}

# Subnet
resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.aws_availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "kubernetes-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "kubernetes-igw"
  }
}

# Route Table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "kubernetes-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.rt.id
}

# Security Group for SSH Access (Allow from any IP)
resource "aws_security_group" "kubernetes_sg" {
  name   = "kubernetes_sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Limit this to known IPs for SSH access.
  }

  # Allow intra-cluster communication on required ports
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 10250
    to_port     = 10255
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kubernetes_sg"
  }
}


# Jumpbox Instance (Public IP with Password Authentication)
resource "aws_instance" "jumpbox" {
  ami                         = var.ami_id
  instance_type               = "t4g.micro"
  vpc_security_group_ids      = [aws_security_group.kubernetes_sg.id]
  subnet_id                   = aws_subnet.subnet.id
  associate_public_ip_address = true
  key_name                    = var.key_pair_name

  root_block_device {
    volume_size = 10
  }

  # Reference the user_data variable
  user_data = var.user_data

  tags = {
    Name = "jumpbox"
  }
}

# Kubernetes Server Instance (Private IP)
resource "aws_instance" "server" {
  ami                         = var.ami_id
  instance_type               = "t4g.small"
  vpc_security_group_ids      = [aws_security_group.kubernetes_sg.id]
  subnet_id                   = aws_subnet.subnet.id
  associate_public_ip_address = false

  root_block_device {
    volume_size = 20
  }

  # Reference the user_data variable
  user_data = var.user_data

  tags = {
    Name = "server"
  }
}

# Worker Nodes Instances (Private IPs)
resource "aws_instance" "node_0" {
  ami                         = var.ami_id
  instance_type               = "t4g.small"
  vpc_security_group_ids      = [aws_security_group.kubernetes_sg.id]
  subnet_id                   = aws_subnet.subnet.id
  associate_public_ip_address = false

  root_block_device {
    volume_size = 20
  }

  # Reference the user_data variable
  user_data = var.user_data

  tags = {
    Name = "node-0"
  }
}

resource "aws_instance" "node_1" {
  ami                         = var.ami_id
  instance_type               = "t4g.small"
  vpc_security_group_ids      = [aws_security_group.kubernetes_sg.id]
  subnet_id                   = aws_subnet.subnet.id
  associate_public_ip_address = false

  root_block_device {
    volume_size = 20
  }

  # Reference the user_data variable
  user_data = var.user_data

  tags = {
    Name = "node-1"
  }
}
