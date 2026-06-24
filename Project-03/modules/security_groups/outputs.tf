output "ext_alb_sg_id" {
  description = "Security group ID for the external ALB"
  value       = aws_security_group.ext_alb.id
}

output "web_sg_id" {
  description = "Security group ID for the web tier"
  value       = aws_security_group.web.id
}

output "int_alb_sg_id" {
  description = "Security group ID for the internal ALB"
  value       = aws_security_group.int_alb.id
}

output "app_sg_id" {
  description = "Security group ID for the app tier"
  value       = aws_security_group.app.id
}

output "db_sg_id" {
  description = "Security group ID for the database tier"
  value       = aws_security_group.db.id
}
