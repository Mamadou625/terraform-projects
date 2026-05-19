output "vpc_id" {
  description = "The ID of the prod VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "The IDs of the prod public subnets"
  value       = module.subnet.public_subnet_ids
}

output "private_subnet_ids" {
  description = "The IDs of the prod private subnets"
  value       = module.subnet.private_subnet_ids
}

output "instance_id" {
  description = "The ID of the prod EC2 instance"
  value       = module.ec2.instance_id
}

output "public_ip" {
  description = "The public IP of the prod EC2 instance"
  value       = module.ec2.public_ip
}
