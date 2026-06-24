variable "project_name" {
  description = "Name prefix for IAM resources"
  type        = string
}

variable "app_bucket_arn" {
  description = "ARN of the S3 bucket holding the application code"
  type        = string
}

variable "db_secret_arn" {
  description = "ARN of the Aurora-managed master password secret in Secrets Manager"
  type        = string
}
