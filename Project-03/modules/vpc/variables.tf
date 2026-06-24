variable "project_name" {
  description = "Name prefix for all VPC resources"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones (one subnet per tier per AZ)"
  type        = list(string)
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for the public (web tier) subnets"
  type        = list(string)
}

variable "app_subnet_cidr_blocks" {
  description = "CIDR blocks for the private (app tier) subnets"
  type        = list(string)
}

variable "db_subnet_cidr_blocks" {
  description = "CIDR blocks for the private (database tier) subnets"
  type        = list(string)
}
