terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Remote state in S3 with native S3 locking (use_lockfile, Terraform >= 1.10).
  # No DynamoDB table required. The bucket is created by ../../bootstrap.
  backend "s3" {
    bucket       = "mamadou-project-03-tfstate"
    key          = "project-03/dev/terraform.tfstate"
    region       = "ca-central-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region
}
