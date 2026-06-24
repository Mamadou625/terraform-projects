variable "project_name" {
  description = "Name prefix for all security group resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC the security groups belong to"
  type        = string
}

variable "app_port" {
  description = "Port the Node.js app tier listens on"
  type        = number
  default     = 4000
}
