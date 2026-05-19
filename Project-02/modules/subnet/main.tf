# Public Subnets
resource "aws_subnet" "public" {
    count                   = 3
    vpc_id                  = var.vpc_id
    cidr_block              = var.public_subnet_cidr_blocks[count.index]
    availability_zone       = var.availability_zones[count.index]
    map_public_ip_on_launch = true

    tags = {
      Name = "${var.project_name}-public-subnet-${count.index + 1}"
    }
}

# Private Subnets
resource "aws_subnet" "private" {
    count             = 3
    vpc_id            = var.vpc_id
    cidr_block        = var.private_subnet_cidr_blocks[count.index]
    availability_zone = var.availability_zones[count.index]

    tags = {
      Name = "${var.project_name}-private-subnet-${count.index + 1}"
    }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = var.vpc_id

    tags = {
      Name = "${var.project_name}-igw"
    }
}

# Public Route Table
resource "aws_route_table" "public" {
    vpc_id = var.vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
      Name = "${var.project_name}-public-rt"
    }
}

# Public Route Table Associations
resource "aws_route_table_association" "public" {
    count          = 3
    subnet_id      = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}

# Private Route Table
resource "aws_route_table" "private" {
    vpc_id = var.vpc_id

    tags = {
      Name = "${var.project_name}-private-rt"
    }
}

# Private Route Table Associations
resource "aws_route_table_association" "private" {
    count          = 3
    subnet_id      = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private.id
}
