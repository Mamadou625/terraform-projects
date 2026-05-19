output "public_subnet_ids" {
    description = "IDs of the 3 public subnets"
    value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
    description = "IDs of the 3 private subnets"
    value       = aws_subnet.private[*].id
}
