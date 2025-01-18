# setup-custom-vpc

This repository provides a Terraform configuration to set up a custom Virtual Private Cloud (VPC) on Amazon Web Services (AWS). The configuration includes the creation of subnets, route tables, and other essential networking components.

### Features
- Custom VPC: Creates a VPC with user-defined CIDR blocks.
- Subnets: Provisions public and private subnets across multiple Availability Zones for high availability.
- Route Tables: Establishes route tables and associates them with the respective subnets.
- Internet Gateway: Deploys an Internet Gateway for public subnet internet access.

### Prerequisites
- Terraform: Ensure that Terraform is installed on your system.
- AWS Credentials: Configure your AWS credentials using the AWS CLI or environment variables.

### Usage

```bash
# clone repo
git clone https://github.com/aifaniyi-aws-labs/terraform-labs.git
cd terraform-labs/001-setup-custom-vpc


# initialize Terraform:
terraform init

# verify script
terraform plan

# deploy
terraform apply

# cleanup when done
terraform destroy
```

### References
For more information on Terraform and AWS VPCs

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)