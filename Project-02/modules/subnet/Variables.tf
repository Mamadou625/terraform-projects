variable "subnet_name" {
    description = "Name of the Subnet"
    type = string
    default = "project-02-subnet"
  
}

variable "vpc_id" {
    description = "The ID of the VPC"
    type = string
  
}

variable "subnet_cidr_block" {
    description = "CIDR block for the Subnet"
    type = string
    default = "10.0.1.0/24"
  
}

variable "availability_zone" {
    description = "Availability zone for the Subnet"
    type = string
    default = "ca-central-1a"
}