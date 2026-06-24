output "bucket_name" {
  description = "Name of the application code bucket"
  value       = aws_s3_bucket.app_code.id
}

output "bucket_arn" {
  description = "ARN of the application code bucket"
  value       = aws_s3_bucket.app_code.arn
}
