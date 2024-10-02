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
resource "aws_security_group" "sg_ssh" {
  name   = "allow_ssh"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from any IP address
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_sg"
  }
}


# Jumpbox Instance (Public IP with Password Authentication)
resource "aws_instance" "jumpbox" {
  ami                         = var.ami_id
  instance_type               = "t4g.micro"
  vpc_security_group_ids      = [aws_security_group.sg_ssh.id]
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
  vpc_security_group_ids      = [aws_security_group.sg_ssh.id]
  subnet_id                   = aws_subnet.subnet.id
  associate_public_ip_address = false

  root_block_device {
    volume_size = 20
  }

  tags = {
    Name = "server"
  }
}

# Worker Nodes Instances (Private IPs)
resource "aws_instance" "node_0" {
  ami                         = var.ami_id
  instance_type               = "t4g.small"
  vpc_security_group_ids      = [aws_security_group.sg_ssh.id]
  subnet_id                   = aws_subnet.subnet.id
  associate_public_ip_address = false

  root_block_device {
    volume_size = 20
  }

  tags = {
    Name = "node-0"
  }
}

resource "aws_instance" "node_1" {
  ami                         = var.ami_id
  instance_type               = "t4g.small"
  vpc_security_group_ids      = [aws_security_group.sg_ssh.id]
  subnet_id                   = aws_subnet.subnet.id
  associate_public_ip_address = false

  root_block_device {
    volume_size = 20
  }

  tags = {
    Name = "node-1"
  }
}
