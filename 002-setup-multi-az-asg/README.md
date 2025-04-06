# Terraform Multi-AZ Auto Scaling Group Setup

This project demonstrates how to use Terraform to create an AWS Auto Scaling Group (ASG) that spans multiple Availability Zones (AZs) for high availability and scalability.

## Features

- **VPC Creation**: Sets up a Virtual Private Cloud (VPC) with public and private subnets across multiple AZs.
- **Auto Scaling Group**: Configures an ASG to manage EC2 instances across the private subnets.
- **Load Balancing**: Integrates an Application Load Balancer (ALB) to distribute incoming traffic across the EC2 instances.
- **Security Groups**: Defines security groups to control inbound and outbound traffic for the ALB and EC2 instances.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed
- AWS credentials configured (e.g., via `aws configure` or environment variables)
- A valid SSH key pair registered in AWS

## Project Structure

- `main.tf`: Initializes the AWS provider.
- `vpc.tf`: Defines the VPC, subnets, and associated networking resources.
- `asg.tf`: Configures the launch template and Auto Scaling Group.
- `variables.tf`: Declares input variables for customization.

## Usage

1. **Initialize Terraform**:

   ```bash
   terraform init

2. **Plan the deployment**:

   ```bash
   terraform plan

3. **Apply the configuration**:

   ```bash
   terraform apply

4. **Cleanup**:

   ```bash
   terraform destroy
