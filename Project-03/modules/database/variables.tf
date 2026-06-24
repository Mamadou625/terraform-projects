variable "project_name" {
  description = "Name prefix for database resources"
  type        = string
}

variable "engine_version" {
  description = "Aurora MySQL engine version"
  type        = string
  default     = "8.0.mysql_aurora.3.12.0"
}

variable "database_name" {
  description = "Initial database name created in the cluster"
  type        = string
}

variable "master_username" {
  description = "Master username for the Aurora cluster"
  type        = string
  default     = "admin"
}

variable "db_subnet_group_name" {
  description = "Name of the DB subnet group (private DB subnets)"
  type        = string
}

variable "db_sg_id" {
  description = "Security group ID for the database tier"
  type        = string
}

variable "instance_count" {
  description = "Number of cluster instances (>=2 for writer + reader multi-AZ)"
  type        = number
  default     = 2
}

variable "instance_class" {
  description = "Instance class for the Aurora cluster instances"
  type        = string
  default     = "db.t3.medium"
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups"
  type        = number
  default     = 7
}

variable "skip_final_snapshot" {
  description = "Skip the final snapshot on destroy (true for dev, false for prod)"
  type        = bool
  default     = true
}
