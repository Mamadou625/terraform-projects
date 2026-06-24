variable "bucket_name" {
  description = "Name of the S3 bucket for application code (must be globally unique)"
  type        = string
}

variable "app_code_dir" {
  description = "Filesystem path to the application-code directory (holds app-tier/ and web-tier/build/)"
  type        = string
}
