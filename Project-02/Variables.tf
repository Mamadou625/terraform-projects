variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
  default     = "project-02-vpc"

}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"

}

variable "subnet_name" {
  type        = string
  description = "Name of the Subnet"
  default     = "project-02-subnet"

}

variable "subnet_cidr_block" {
  type        = string
  description = "CIDR block for the Subnet"
  default     = "10.0.1.0/24"

}

variable "ami_id" {
  type = string
  default = "ami-0eacb8127f9b58e90"
}