# Creation of my project VPC and subnet

resource "aws_vpc" "project-01_vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "dev-vpc"
    Environment = "dev"
  }
}

resource "aws_subnet" "project-01_subnet" {
  vpc_id                  = aws_vpc.project-01_vpc.id
  cidr_block              = "10.10.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ca-central-1a"
  tags = {
    Name        = "dev-public-subnet"
    Environment = "dev"
  }
}

# Create an internet gateway and route table for the VPC  

resource "aws_internet_gateway" "project-01_igw" {
  vpc_id = aws_vpc.project-01_vpc.id
  tags = {
    Name        = "dev-internet-gateway"
    Environment = "dev"
  }
}

resource "aws_route_table" "project-01_route_table" {
  vpc_id = aws_vpc.project-01_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project-01_igw.id
  }
  tags = {
    Name        = "dev-public-route-table"
    Environment = "dev"
  }
}

resource "aws_route_table_association" "project-01_route_table_assoc" {
  subnet_id      = aws_subnet.project-01_subnet.id
  route_table_id = aws_route_table.project-01_route_table.id
}