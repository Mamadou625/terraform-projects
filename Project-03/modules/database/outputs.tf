output "cluster_endpoint" {
  description = "Writer endpoint for the Aurora cluster"
  value       = aws_rds_cluster.aurora.endpoint
}

output "reader_endpoint" {
  description = "Reader endpoint for the Aurora cluster"
  value       = aws_rds_cluster.aurora.reader_endpoint
}

output "database_name" {
  description = "Name of the initial database"
  value       = aws_rds_cluster.aurora.database_name
}

output "master_secret_arn" {
  description = "ARN of the Secrets Manager secret holding the master credentials"
  value       = aws_rds_cluster.aurora.master_user_secret[0].secret_arn
}
