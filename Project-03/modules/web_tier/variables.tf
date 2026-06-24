variable "project_name" {
  description = "Name prefix for web tier resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the web tier (ASG + external ALB)"
  type        = list(string)
}

variable "ext_alb_sg_id" {
  description = "Security group ID for the external ALB"
  type        = string
}

variable "web_sg_id" {
  description = "Security group ID for the web tier instances"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the web tier instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the web tier"
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

variable "internal_alb_dns" {
  description = "DNS name of the internal ALB (for nginx /api proxy_pass)"
  type        = string
}

variable "asg_min_size" {
  description = "Minimum number of web tier instances"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum number of web tier instances"
  type        = number
  default     = 4
}

variable "asg_desired_capacity" {
  description = "Desired number of web tier instances"
  type        = number
  default     = 2
}

variable "cpu_target_value" {
  description = "Target average CPU utilization for scaling"
  type        = number
  default     = 50
}
