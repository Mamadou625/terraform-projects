# Creation of my Subnet
resource "aws_subnet" "subnet" {
    vpc_id            = var.vpc_id
    cidr_block        = var.subnet_cidr_block
    availability_zone = var.availability_zone

    tags = {
      Name = var.subnet_name
    }
  
}

# Creation of my Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = var.vpc_id

    tags = {
      Name = "${var.subnet_name}-igw"
    }
}

# Creation of my Route Table
resource "aws_route_table" "rt" {
    vpc_id = var.vpc_id

    route = {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
      Name = "${var.subnet_name}-rt"
    }
}

# Creation of my Route Table Association
resource "aws_route_table_association" "rta" {
    subnet_id      = aws_subnet.subnet.id
    route_table_id = aws_route_table.rt.id
}