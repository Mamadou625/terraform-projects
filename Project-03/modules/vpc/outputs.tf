output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "IDs of the public (web tier) subnets"
  value       = aws_subnet.public[*].id
}

output "app_subnet_ids" {
  description = "IDs of the private (app tier) subnets"
  value       = aws_subnet.private_app[*].id
}

output "db_subnet_ids" {
  description = "IDs of the private (database tier) subnets"
  value       = aws_subnet.private_db[*].id
}

output "db_subnet_group_name" {
  description = "Name of the database subnet group"
  value       = aws_db_subnet_group.db.name
}
