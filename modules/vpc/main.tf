# Create VPC
resource "aws_vpc" "jenkins_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
    Env  = var.env
    Type = var.type
  }
}

# Create Internet Gateway and attach it to VPC
resource "aws_internet_gateway" "jenkins_internet_gateway" {
  vpc_id = aws_vpc.jenkins_vpc.id

  tags = {
    Name = "${var.project_name}-igw"
    Env  = var.env
    Type = var.type
  }
}

# Using data source to get all Avalablility Zones in region
data "aws_availability_zones" "available_zones" {}

# Create Public Subnet AZ1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.jenkins_vpc.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet az1"
    Env  = var.env
    Type = var.type
  }
}

# Create Public Subnet AZ2
resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.jenkins_vpc.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet az2"
    Env  = var.env
    Type = var.type
  }
}

# Create Public Subnet AZ3
resource "aws_subnet" "public_subnet_az3" {
  vpc_id                  = aws_vpc.jenkins_vpc.id
  cidr_block              = var.public_subnet_az3_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[2]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet az3"
    Env  = var.env
    Type = var.type
  }
}

# Create Route Table and add Public Route
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.jenkins_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jenkins_internet_gateway.id
  }

  tags = {
    Name = "Public Route Table"
    Env  = var.env
    Type = var.type
  }
}

# Associate Public Subnet in AZ1 to route table
resource "aws_route_table_association" "public_subnet_az1_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}

# Associate Public Subnet in AZ2 to route table
resource "aws_route_table_association" "public_subnet_az2_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_route_table.id
}

# Associate Public Subnet in AZ3 to route table
resource "aws_route_table_association" "public_subnet_az3_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_az3.id
  route_table_id = aws_route_table.public_route_table.id
}

# Creating NACL
resource "aws_network_acl" "jenkins_nacl" {
  vpc_id = aws_vpc.jenkins_vpc.id

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}