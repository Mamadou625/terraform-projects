variable "project_name" {
  description = "Name prefix for app tier resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "app_subnet_ids" {
  description = "Private subnet IDs for the app tier (ASG + internal ALB)"
  type        = list(string)
}

variable "int_alb_sg_id" {
  description = "Security group ID for the internal ALB"
  type        = string
}

variable "app_sg_id" {
  description = "Security group ID for the app tier instances"
  type        = string
}

variable "app_port" {
  description = "Port the Node.js app listens on"
  type        = number
  default     = 4000
}

variable "ami_id" {
  description = "AMI ID for the app tier instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the app tier"
  type        = string
}

variable "instance_profile_name" {
  description = "EC2 instance profile name"
  type        = string
}

variable "s3_bucket" {
  description = "Name of the S3 bucket holding the application code"
  type        = string
}

variable "db_secret_arn" {
  description = "ARN of the Aurora-managed master secret"
  type        = string
}

variable "db_endpoint" {
  description = "Aurora writer endpoint"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "aws_region" {
  description = "AWS region (for the secretsmanager CLI call in user-data)"
  type        = string
}

variable "asg_min_size" {
  description = "Minimum number of app tier instances"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum number of app tier instances"
  type        = number
  default     = 4
}

variable "asg_desired_capacity" {
  description = "Desired number of app tier instances"
  type        = number
  default     = 2
}

variable "cpu_target_value" {
  description = "Target average CPU utilization for scaling"
  type        = number
  default     = 50
}
