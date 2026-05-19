variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "project_name" {
  description = "Name prefix for all subnet resources"
  type        = string
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for the 3 public subnets"
  type        = list(string)
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for the 3 private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of 3 availability zones for the subnets"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "sg_name" {
  description = "Name of the Security Group"
  type        = string
}
