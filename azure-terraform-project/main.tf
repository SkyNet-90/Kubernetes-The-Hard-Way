terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "kubernetes-the-hard-way-rg"
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "kubernetes-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "kubernetes-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "kubernetes-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow_ssh_jumpbox"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.public_ip # Limit SSH to only your IP
    destination_address_prefix = "*"
  }
}

# Public IP for Jumpbox (Only Jumpbox gets public access)
resource "azurerm_public_ip" "jumpbox_ip" {
  name                = "jumpbox-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

# Network Interfaces (Only Jumpbox gets a public IP)
resource "azurerm_network_interface" "nic" {
  count               = 4
  name                = "kubernetes-nic-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"

    # Assign public IP to Jumpbox only
    public_ip_address_id = count.index == 0 ? azurerm_public_ip.jumpbox_ip.id : null
  }
}

# Storage Account for Boot Diagnostics
resource "azurerm_storage_account" "sa" {
  name                     = "diagstorageacct9302024"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_linux_virtual_machine" "jumpbox" {
  name                = "jumpbox"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1ms"
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.nic[0].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30  # Update disk size to 30 GB
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-12"
    sku       = "12-gen2"
    version   = "latest"
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }

  tags = {
    environment = "dev"
    owner       = "cloud-engineering"
  }
}

# Server VM (No public IP)
resource "azurerm_linux_virtual_machine" "server" {
  name                = "server"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2ms" # 1 CPU, 2GB RAM for ARM64
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.nic[1].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30  # Update disk size to 30 GB
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-12"
    sku       = "12-gen2"
    version   = "latest"
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }

  tags = {
    environment = "dev"
    owner       = "cloud-engineering"
  }
}

# Worker Node 0 VM (No public IP)
resource "azurerm_linux_virtual_machine" "node_0" {
  name                = "node-0"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2ms"
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.nic[2].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30  # Update disk size to 30 GB
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-12"
    sku       = "12-gen2"
    version   = "latest"
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }

  tags = {
    environment = "dev"
    owner       = "cloud-engineering"
  }
}

# Worker Node 1 VM (No public IP)
resource "azurerm_linux_virtual_machine" "node_1" {
  name                = "node-1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2ms"
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.nic[3].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30  # Update disk size to 30 GB
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-12"
    sku       = "12-gen2"
    version   = "latest"
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }

  tags = {
    environment = "dev"
    owner       = "cloud-engineering"
  }
}