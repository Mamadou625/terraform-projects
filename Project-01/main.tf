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

# Creation of a security group for the EC2 instance
resource "aws_security_group" "project-01_security_group" {
  name        = "dev-security-group"
  description = "Security group for dev instances"
  vpc_id      = aws_vpc.project-01_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "dev"
  }
}

# Creation of a key pair for the EC2 instance

resource "aws_key_pair" "project-01_key_pair" {
  key_name   = "Project-01-Key-Pair"
  public_key = file("~/.ssh/id_ed25519.pub")
}

# Creation of an EC2 instance in the public subnet

resource "aws_instance" "project-01_ec2_instance" {
  ami             = data.aws_ami.amazon_linux_2.id
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.project-01_subnet.id
  key_name        = aws_key_pair.project-01_key_pair.id
  security_groups = [aws_security_group.project-01_security_group.id]
  user_data      = file("userdata.tpl")

  tags = {
    Name        = "dev-ec2-instance"
    Environment = "dev"
  }
}