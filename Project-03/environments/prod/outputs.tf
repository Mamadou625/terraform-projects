output "web_alb_dns" {
  description = "Public DNS of the web tier ALB (open this in a browser)"
  value       = module.web_tier.web_alb_dns
}

output "internal_alb_dns" {
  description = "DNS of the internal app tier ALB"
  value       = module.app_tier.internal_alb_dns
}

output "aurora_endpoint" {
  description = "Aurora writer endpoint"
  value       = module.database.cluster_endpoint
}

output "aurora_reader_endpoint" {
  description = "Aurora reader endpoint"
  value       = module.database.reader_endpoint
}

output "app_code_bucket" {
  description = "S3 bucket for application code"
  value       = module.s3.bucket_name
}
