
# Step 1: Configure the AWS Provider and region
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3"
}

# Step 2: Create a VPC
resource "aws_vpc" "sample_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "sample_vpc"
  }
}

# Step 3: Create 2 public and 2 private subnets in the VPC
resource "aws_subnet" "public_subnet_1" {
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.sample_vpc.id
  availability_zone = "eu-west-3a"
  tags = {
    "Name" : "public subnet 1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  cidr_block        = "10.0.2.0/24"
  vpc_id            = aws_vpc.sample_vpc.id
  availability_zone = "eu-west-3b"
  tags = {
    "Name" : "public subnet 2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  cidr_block        = "10.0.3.0/24"
  vpc_id            = aws_vpc.sample_vpc.id
  availability_zone = "eu-west-3a"
  tags = {
    "Name" : "private subnet 1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  cidr_block        = "10.0.4.0/24"
  vpc_id            = aws_vpc.sample_vpc.id
  availability_zone = "eu-west-3b"
  tags = {
    "Name" : "private subnet 2"
  }
}

# Step 4: Create an internet gateway for the VPC
resource "aws_internet_gateway" "sample_igw" {
  vpc_id = aws_vpc.sample_vpc.id
  tags = {
    "Name" : "sample igw"
  }
}

# Step 5: Create a route table for the VPC
resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.sample_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sample_igw.id
  }
}

# Step 6: Associate the public subnets with the route table
resource "aws_route_table_association" "public_route_table_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

resource "aws_route_table_association" "public_route_table_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}
