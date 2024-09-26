# Azure Kubernetes The Hard Way Terraform Project
This project uses Terraform to provision four Azure virtual machines and the necessary networking resources to ensure they are connected within a single resource group. The VMs are configured to run Debian 12 (bookworm) and meet the following specifications:

| Name    | Description           | CPU | RAM   | Storage |
|---------|-----------------------|-----|-------|---------|
| jumpbox | Administration host   | 1   | 512MB | 10GB    |
| server  | Kubernetes server     | 1   | 2GB   | 20GB    |
| node-0  | Kubernetes worker node| 1   | 2GB   | 20GB    |
| node-1  | Kubernetes worker node| 1   | 2GB   | 20GB    |

## Project Structure

- `main.tf`: Contains the main Terraform configuration for provisioning the resources.
- `variables.tf`: Defines the input variables for the Terraform configuration.
- `outputs.tf`: Specifies the outputs of the Terraform configuration.
- `terraform.tfvars`: Contains the values for the input variables.
- `README.md`: This file, providing an overview of the project.

## Prerequisites

- Terraform installed on your local machine.
- An Azure account with sufficient permissions to create resources.
- Azure CLI installed and authenticated.

## Configuration

1. Generate an SSH key pair if you don't already have one:
    ```sh
    ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
    ```

2. Update the `terraform.tfvars` file with your specific values:
    ```hcl
    location             = "East US"
    admin_username       = "azureuser"
    admin_ssh_public_key = "ssh-rsa312423432424 example"
    ```

## Usage

1. Clone the repository:
    ```sh
    git clone https://github.com/SkyNet-90/Kubernetes-The-Hard-Way
    cd azure-terraform-project
    ```

2. Initialize the Terraform configuration:
    ```sh
    terraform init
    ```

3. Apply the Terraform configuration:
    ```sh
    terraform apply
    ```

    Review the plan and type `yes` to apply.

## Outputs

After applying the configuration, Terraform will output the public and private IP addresses of the VMs. You can use these IP addresses to connect to your VMs.

## Cleaning Up

To destroy the resources created by Terraform, run:
```sh
terraform destroy
```

## Security Considerations

- SSH Access: Ensure that the source_address_prefix in the Network Security Group is set to your public IP address to restrict SSH access.
- Sensitive Data: Do not commit sensitive data such as passwords or private keys to version control. Use environment variables or a secrets management service to handle sensitive information securely.