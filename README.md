# Kubernetes The Hard Way Terraform Projects

This repository contains Terraform configurations to provision virtual machines and necessary networking resources on both Azure and AWS. The VMs are configured to run Debian 12 (bookworm) and meet the following specifications:

| Name    | Description           | CPU | RAM   | Storage |
|---------|-----------------------|-----|-------|---------|
| jumpbox | Administration host   | 1   | 512MB | 10GB    |
| server  | Kubernetes server     | 1   | 2GB   | 20GB    |
| node-0  | Kubernetes worker node| 1   | 2GB   | 20GB    |
| node-1  | Kubernetes worker node| 1   | 2GB   | 20GB    |

## Project Structure

### Azure Terraform Project

- `azure-terraform-project/main.tf`: Contains the main Terraform configuration for provisioning the resources on Azure.
- `azure-terraform-project/variables.tf`: Defines the input variables for the Terraform configuration.
- `azure-terraform-project/outputs.tf`: Specifies the outputs of the Terraform configuration.
- `azure-terraform-project/terraform.tfvars`: Contains the values for the input variables.
- `azure-terraform-project/README.md`: This file, providing an overview of the Azure project.

### AWS Terraform Project

- `aws-terraform-project/main.tf`: Contains the main Terraform configuration for provisioning the resources on AWS.
- `aws-terraform-project/variables.tf`: Defines the input variables for the Terraform configuration.
- `aws-terraform-project/outputs.tf`: Specifies the outputs of the Terraform configuration.
- `aws-terraform-project/terraform.tfvars`: Contains the values for the input variables.
- `aws-terraform-project/README.md`: This file, providing an overview of the AWS project.

## Prerequisites

- Terraform installed on your local machine.
- An Azure account with sufficient permissions to create resources (for Azure project).
- An AWS account with sufficient permissions to create resources (for AWS project).
- Azure CLI installed and authenticated (for Azure project).
- AWS CLI installed and authenticated (for AWS project).

## Configuration

### Azure Project

1. Generate an SSH key pair if you don't already have one:
    ```sh
    ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
    ```

2. Update the `azure-terraform-project/terraform.tfvars` file with your specific values:
    ```hcl
    location             = "East US"
    admin_username       = "azureuser"
    admin_ssh_public_key = "ssh-rsa312423432424 example"
    ```

### AWS Project

1. Generate an SSH key pair if you don't already have one:
    ```sh
    ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
    ```

2. Extract the public key from the `.pem` file:
    ```sh
    ssh-keygen -y -f "path/to/your/private/key.pem" > "path/to/your/public/key.pub"
    ```

3. Update the `aws-terraform-project/terraform.tfvars` file with your specific values:
    ```hcl
    aws_region            = "us-east-1"
    aws_availability_zone = "us-east-1a"
    allowed_ip            = "your_public_ip/32"
    ami_id                = "ami-0789039e34e739d67"
    public_key_path       = "path/to/your/public/key.pub"
    ```

## Usage

### Azure Project

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

    Review the plan and type [`yes`](command:_github.copilot.openSymbolFromReferences?%5B%22yes%22%2C%5B%7B%22uri%22%3A%7B%22%24mid%22%3A1%2C%22fsPath%22%3A%22c%3A%5C%5CUsers%5C%5Cmatthewss%5C%5CDocuments%5C%5CKubernetes%20The%20Hard%20Way%5C%5CREADME.md%22%2C%22_sep%22%3A1%2C%22external%22%3A%22file%3A%2F%2F%2Fc%253A%2FUsers%2Fmatthewss%2FDocuments%2FKubernetes%2520The%2520Hard%2520Way%2FREADME.md%22%2C%22path%22%3A%22%2Fc%3A%2FUsers%2Fmatthewss%2FDocuments%2FKubernetes%20The%20Hard%20Way%2FREADME.md%22%2C%22scheme%22%3A%22file%22%7D%2C%22pos%22%3A%7B%22line%22%3A56%2C%22character%22%3A30%7D%7D%2C%7B%22uri%22%3A%7B%22%24mid%22%3A1%2C%22fsPath%22%3A%22c%3A%5C%5CUsers%5C%5Cmatthewss%5C%5CDocuments%5C%5CKubernetes%20The%20Hard%20Way%5C%5CREADME.md%22%2C%22_sep%22%3A1%2C%22external%22%3A%22file%3A%2F%2F%2Fc%253A%2FUsers%2Fmatthewss%2FDocuments%2FKubernetes%2520The%2520Hard%2520Way%2FREADME.md%22%2C%22path%22%3A%22%2Fc%3A%2FUsers%2Fmatthewss%2FDocuments%2FKubernetes%20The%20Hard%20Way%2FREADME.md%22%2C%22scheme%22%3A%22file%22%7D%2C%22pos%22%3A%7B%22line%22%3A56%2C%22character%22%3A30%7D%7D%5D%5D "Go to definition") to apply.

### AWS Project

1. Clone the repository:
    ```sh
    git clone https://github.com/SkyNet-90/Kubernetes-The-Hard-Way
    cd aws-terraform-project
    ```

2. Initialize the Terraform configuration:
    ```sh
    terraform init
    ```

3. Apply the Terraform configuration:
    ```sh
    terraform apply
    ```

    Review the plan and type [`yes`](command:_github.copilot.openSymbolFromReferences?%5B%22yes%22%2C%5B%7B%22uri%22%3A%7B%22%24mid%22%3A1%2C%22fsPath%22%3A%22c%3A%5C%5CUsers%5C%5Cmatthewss%5C%5CDocuments%5C%5CKubernetes%20The%20Hard%20Way%5C%5CREADME.md%22%2C%22_sep%22%3A1%2C%22external%22%3A%22file%3A%2F%2F%2Fc%253A%2FUsers%2Fmatthewss%2FDocuments%2FKubernetes%2520The%2520Hard%2520Way%2FREADME.md%22%2C%22path%22%3A%22%2Fc%3A%2FUsers%2Fmatthewss%2FDocuments%2FKubernetes%20The%20Hard%20Way%2FREADME.md%22%2C%22scheme%22%3A%22file%22%7D%2C%22pos%22%3A%7B%22line%22%3A56%2C%22character%22%3A30%7D%7D%2C%7B%22uri%22%3A%7B%22%24mid%22%3A1%2C%22fsPath%22%3A%22c%3A%5C%5CUsers%5C%5Cmatthewss%5C%5CDocuments%5C%5CKubernetes%20The%20Hard%20Way%5C%5CREADME.md%22%2C%22_sep%22%3A1%2C%22external%22%3A%22file%3A%2F%2F%2Fc%253A%2FUsers%2Fmatthewss%2FDocuments%2FKubernetes%2520The%2520Hard%2520Way%2FREADME.md%22%2C%22path%22%3A%22%2Fc%3A%2FUsers%2Fmatthewss%2FDocuments%2FKubernetes%20The%20Hard%20Way%2FREADME.md%22%2C%22scheme%22%3A%22file%22%7D%2C%22pos%22%3A%7B%22line%22%3A56%2C%22character%22%3A30%7D%7D%5D%5D "Go to definition") to apply.

## Outputs

After applying the configuration, Terraform will output the public and private IP addresses of the VMs. You can use these IP addresses to connect to your VMs.

## Cleaning Up

To destroy the resources created by Terraform, run:
```sh
terraform destroy
## Security Considerations

- SSH Access: Ensure that the source_address_prefix in the Network Security Group is set to your public IP address to restrict SSH access.
- Sensitive Data: Do not commit sensitive data such as passwords or private keys to version control. Use environment variables or a secrets management service to handle sensitive information securely.