variable "aws_region" {
  description = "AWS region for the state bucket and CI role"
  type        = string
  default     = "ca-central-1"
}

variable "project_name" {
  description = "Name prefix for bootstrap resources"
  type        = string
  default     = "project-03"
}

variable "state_bucket_name" {
  description = "Globally unique name for the Terraform remote state bucket (must match the backend block in environments/*/providers.tf)"
  type        = string
  default     = "mamadou-project-03-tfstate"
}

variable "github_owner" {
  description = "GitHub account/org that owns the repository"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name (without owner)"
  type        = string
}
