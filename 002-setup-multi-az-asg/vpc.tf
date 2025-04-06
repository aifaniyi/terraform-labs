resource "aws_vpc" "sample_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "sample_vpc"
  }
}

# public subnets
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

# private subnets
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

# internet gateway
resource "aws_internet_gateway" "sample_igw" {
  vpc_id = aws_vpc.sample_vpc.id
  tags = {
    "Name" : "sample igw"
  }
}

# route table for public subnets
# route traffic to internet gateway
resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.sample_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sample_igw.id
  }
}

resource "aws_route_table_association" "public_route_table_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

resource "aws_route_table_association" "public_route_table_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

# elastic ip for nat gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

# nat gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "NAT-Gateway"
  }
}

# route table for private subnet
# route traffic to nat gateway
resource "aws_route_table" "private_subnet_route_table" {
  vpc_id = aws_vpc.sample_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private route table"
  }
}

resource "aws_route_table_association" "private_route_table_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_subnet_route_table.id
}

resource "aws_route_table_association" "private_route_table_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_subnet_route_table.id
}
