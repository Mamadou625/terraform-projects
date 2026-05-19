variable "project_name" {
    description = "Name prefix for all subnet resources"
    type        = string
    default     = "project-02"
}

variable "vpc_id" {
    description = "The ID of the VPC"
    type        = string
}

variable "public_subnet_cidr_blocks" {
    description = "CIDR blocks for the 3 public subnets"
    type        = list(string)
    default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidr_blocks" {
    description = "CIDR blocks for the 3 private subnets"
    type        = list(string)
    default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "availability_zones" {
    description = "List of 3 availability zones for the subnets"
    type        = list(string)
    default     = ["ca-central-1a", "ca-central-1b", "ca-central-1d"]
}
