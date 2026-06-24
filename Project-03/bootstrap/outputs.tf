output "state_bucket_name" {
  description = "Name of the Terraform remote state bucket"
  value       = aws_s3_bucket.tfstate.id
}

output "ci_role_arn" {
  description = "ARN of the GitHub Actions CI role (set as the AWS_CI_ROLE_ARN repo variable)"
  value       = aws_iam_role.ci.arn
}

output "oidc_provider_arn" {
  description = "ARN of the GitHub Actions OIDC provider"
  value       = aws_iam_openid_connect_provider.github.arn
}
