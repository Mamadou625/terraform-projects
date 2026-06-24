variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
}

# --- Networking ---
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones (one subnet per tier per AZ)"
  type        = list(string)
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for the public (web) subnets"
  type        = list(string)
}

variable "app_subnet_cidr_blocks" {
  description = "CIDR blocks for the private (app) subnets"
  type        = list(string)
}

variable "db_subnet_cidr_blocks" {
  description = "CIDR blocks for the private (db) subnets"
  type        = list(string)
}

# --- Application / compute ---
variable "app_port" {
  description = "Port the Node.js app listens on"
  type        = number
  default     = 4000
}

variable "app_bucket_name" {
  description = "Globally unique S3 bucket name for application code"
  type        = string
}

variable "web_instance_type" {
  description = "Instance type for the web tier"
  type        = string
  default     = "t3.micro"
}

variable "app_instance_type" {
  description = "Instance type for the app tier"
  type        = string
  default     = "t3.micro"
}

variable "web_asg_min_size" {
  description = "Web tier ASG minimum size"
  type        = number
  default     = 2
}

variable "web_asg_max_size" {
  description = "Web tier ASG maximum size"
  type        = number
  default     = 4
}

variable "web_asg_desired_capacity" {
  description = "Web tier ASG desired capacity"
  type        = number
  default     = 2
}

variable "app_asg_min_size" {
  description = "App tier ASG minimum size"
  type        = number
  default     = 2
}

variable "app_asg_max_size" {
  description = "App tier ASG maximum size"
  type        = number
  default     = 4
}

variable "app_asg_desired_capacity" {
  description = "App tier ASG desired capacity"
  type        = number
  default     = 2
}

# --- Database ---
variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "webappdb"
}

variable "db_master_username" {
  description = "Aurora master username"
  type        = string
  default     = "admin"
}

variable "db_instance_count" {
  description = "Number of Aurora cluster instances (>=2 for multi-AZ)"
  type        = number
  default     = 2
}

variable "db_instance_class" {
  description = "Aurora instance class"
  type        = string
  default     = "db.t3.medium"
}

variable "db_skip_final_snapshot" {
  description = "Skip the final snapshot on destroy"
  type        = bool
  default     = true
}
